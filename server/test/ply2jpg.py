import numpy as np
import os
import cv2
from plyfile import PlyData

def read_ply(file_path):
    with open(file_path, 'rb') as f:
        plydata = PlyData.read(f)
        vertices = plydata['vertex']
        x = vertices['x']
        y = vertices['y']
        z = vertices['z']
        red = vertices['red']
        green = vertices['green']
        blue = vertices['blue']
    return np.vstack((x, y, z, red, green, blue)).T

def generate_top_down_image(point_cloud, resolution=(255, 255)):
    # Extract x, y coordinates, and colors of the point cloud
    x = point_cloud[::-1, 0]
    y = point_cloud[::-1, 2]
    colors = point_cloud[::-1, 3:]  # Normalize colors to range [0, 1]
    
    topdown_image = np.zeros((resolution[0], resolution[1], 3), dtype=np.uint8)

    # Scale and shift coordinates to fit into the image resolution
    x_scaled = ((x - np.min(x)) / (np.max(x) - np.min(x))) * (resolution[0] - 1)
    y_scaled = ((y - np.min(y)) / (np.max(y) - np.min(y))) * (resolution[1] - 1)

    # Round coordinates to integers
    x_scaled = np.round(x_scaled).astype(int)
    y_scaled = np.round(y_scaled).astype(int)

    for i in range(len(x_scaled)):
        topdown_image[y_scaled[i], x_scaled[i]] = colors[i]

    return topdown_image

def run_convertion(ply_folder, image_folder):
    for file in os.listdir(ply_folder):
        point_cloud = read_ply(os.path.join(ply_folder, file))
        image = cv2.cvtColor(generate_top_down_image(point_cloud), cv2.COLOR_RGB2BGR)
        cv2.imwrite(os.path.join(image_folder, file.split('.')[0]+'.jpg'), image)
