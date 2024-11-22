#!/usr/bin/env python3

import numpy as np
import imageio.v3 as iio 
import matplotlib.pyplot as plt
from skimage import io

# Gene names, fields, and channels
genes = ['SRSF1', 'POLR2B', 'PIM2', 'APEX1']
fields = ['field0', 'field1']
channels = ['PCNA', 'nascentRNA', 'DAPI']

# Function to load images and organize data
def load_image_data(genes, fields, channels):
    image_data = {}
    for gene in genes:
        for field in fields:
            channel_images = []
            for channel in channels:
                file_name = f"{gene}_{field}_{channel}.tif"
                try:
                    img = iio.imread(file_name)
                    img = img.astype(np.uint16)
                    channel_images.append(img)
                except FileNotFoundError:
                    print(f"File not found: {file_name}")
            # Fill missing channels with zeros if incomplete
            if len(channel_images) < len(channels):
                print(f"Incomplete data for {gene} {field}")
                while len(channel_images) < len(channels):
                    missing_shape = channel_images[0].shape if channel_images else (520, 616)  # Replace with your dimensions
                    channel_images.append(np.zeros(missing_shape, dtype=np.uint16))
            # Stack channels
            stacked_image = np.stack(channel_images, axis=-1)
            image_data[f"{gene}_{field}"] = stacked_image
            print(f"{gene}_{field}: {stacked_image.shape}")  # Final array confirmation
    return image_data

# Load in image data
image_data = load_image_data(genes, fields, channels)

# Check the output
for key, value in image_data.items():
    print(f"{key}: {value.shape}")

