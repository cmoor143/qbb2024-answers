#!/usr/bin/env python3

import os
import numpy as np
import pandas as pd
from skimage import io
from scipy.ndimage import label

# Define gene names, fields, and channels
genes = ["SRSF1", "POLR2B", "PIM2", "APEX1"]
fields = ["field0", "field1"]
channels = ["PCNA", "nascentRNA", "DAPI"]

def load_image_data(genes, fields, channels):
    """Loads image data into a dictionary with shape (X, Y, 3)."""
    image_data = {}
    
    for gene in genes:
        for field in fields:
            images = []
            for channel in channels:
                file_name = f"{gene}_{field}_{channel}.tif"
                if os.path.exists(file_name):
                    image = io.imread(file_name).astype(np.uint16)
                    images.append(image)
                else:
                    print(f"Incomplete data for {gene} {field}")
                    break
            if len(images) == len(channels):
                # Stack the three channels into a single array
                image_data[f"{gene}_{field}"] = np.stack(images, axis=-1)
    
    return image_data

def create_dapi_mask(dapi_channel):
    """Creates a binary mask from the DAPI channel."""
    threshold = np.mean(dapi_channel)
    mask = dapi_channel >= threshold
    return mask

def find_labels(mask):
    """Finds and labels connected components in a binary mask."""
    labeled_array, num_features = label(mask)
    return labeled_array, num_features

def filter_by_size(label_array, min_size=100, max_size=np.inf):
    """Filters labeled objects by size, removing small and large outliers."""
    sizes = np.bincount(label_array.ravel())
    sizes[0] = 0  # Ignore background (label 0)
    
    valid_labels = np.where((sizes >= min_size) & (sizes <= max_size))[0]
    filtered_labels = np.isin(label_array, valid_labels) * label_array
    return filtered_labels

def calculate_signals(image, label_array):
    """Calculates mean PCNA, nascent RNA signals, and log2 ratio for each nucleus."""
    pcna_channel = image[..., 0]
    nascent_channel = image[..., 1]
    
    pcna_signals = []
    nascent_signals = []
    log2_ratios = []
    
    # Iterate over labels (excluding 0, the background)
    for label_id in range(1, np.amax(label_array) + 1):
        where = np.where(label_array == label_id)
        
        pcna_signal = np.mean(pcna_channel[where])
        nascent_signal = np.mean(nascent_channel[where])
        log2_ratio = np.log2(nascent_signal / pcna_signal) if pcna_signal > 0 else np.nan
        
        pcna_signals.append(pcna_signal)
        nascent_signals.append(nascent_signal)
        log2_ratios.append(log2_ratio)
    
    return pcna_signals, nascent_signals, log2_ratios

def process_images(image_data):
    """Processes images to calculate signal values."""
    results = []
    
    for key, image in image_data.items():
        gene, field = key.split("_")
        
        # Step 2.1: Create mask
        dapi_channel = image[..., 2]
        mask = create_dapi_mask(dapi_channel)
        
        # Step 2.2: Find labels
        label_array, _ = find_labels(mask)
        
        # Step 2.3: Filter by size
        filtered_labels = filter_by_size(label_array, min_size=100)
        
        # Step 3.1: Calculate signals
        pcna_signals, nascent_signals, log2_ratios = calculate_signals(image, filtered_labels)
        
        # Combine results
        for pcna, nascent, ratio in zip(pcna_signals, nascent_signals, log2_ratios):
            results.append((gene, pcna, nascent, ratio))
    
    return results

def save_results(results):
    """Saves results to a CSV file."""
    df = pd.DataFrame(results, columns=["Gene", "PCNA", "NascentRNA", "Log2Ratio"])
    df.to_csv("nucleus_signals.csv", index=False)
    print("Results saved to nucleus_signals.csv")

if __name__ == "__main__":
    # Load images
    image_data = load_image_data(genes, fields, channels)
    
    # Process images
    results = process_images(image_data)
    
    # Save results to CSV
    save_results(results)
