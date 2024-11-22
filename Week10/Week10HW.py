#!/usr/bin/env python3

import os
import numpy as np
import matplotlib.pyplot as plt
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
                print(f"{gene}_{field}: {image_data[f'{gene}_{field}'].shape}")
    
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

def filter_by_statistical_size(label_array):
    """Filters labels by mean ± standard deviation of their sizes."""
    sizes = np.bincount(label_array.ravel())
    sizes[0] = 0  # Ignore background
    
    mean_size = np.mean(sizes[sizes > 0])
    std_size = np.std(sizes[sizes > 0])
    
    lower_bound = mean_size - std_size
    upper_bound = mean_size + std_size
    
    return filter_by_size(label_array, min_size=lower_bound, max_size=upper_bound)

def process_images(image_data):
    """Processes images: segmentation, labeling, and filtering."""
    for key, image in image_data.items():
        dapi_channel = image[:, :, 2]  # Extract DAPI channel
        
        # Step 2.1: Create binary mask
        mask = create_dapi_mask(dapi_channel)
        
        # Step 2.2: Generate label map
        label_array, num_labels = find_labels(mask)
        print(f"{key}: Found {num_labels} initial labels.")
        
        # Step 2.3: Filter outliers by size
        filtered_label_array = filter_by_size(label_array, min_size=100)
        final_label_array = filter_by_statistical_size(filtered_label_array)
        
        # Visualize results
        plt.figure(figsize=(12, 4))
        plt.subplot(1, 3, 1)
        plt.imshow(mask, cmap='gray')
        plt.title(f"Binary Mask: {key}")
        
        plt.subplot(1, 3, 2)
        plt.imshow(label_array, cmap='nipy_spectral')
        plt.title(f"Labeled: {key}")
        
        plt.subplot(1, 3, 3)
        plt.imshow(final_label_array, cmap='nipy_spectral')
        plt.title(f"Filtered Labels: {key}")
        
        plt.tight_layout()
        plt.show()

# Main script
if __name__ == "__main__":
    # Step 1: Load image data
    image_data = load_image_data(genes, fields, channels)
    
    # Step 2: Process images for segmentation and filtering
    process_images(image_data)