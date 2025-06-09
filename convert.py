import struct
import numpy as np
import os

# ==== CONFIGURATION ====
THRESHOLD = 128
OUTPUT_DIR = "/Users/alexanderciccarelli/Desktop/Lab2/MNIST_testing_binary_and_label"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# ==== FUNCTIONS ====
def read_idx_images(path):
    with open(path, 'rb') as f:
        magic, num, rows, cols = struct.unpack('>IIII', f.read(16))
        assert magic == 2051
        data = np.frombuffer(f.read(), dtype=np.uint8).reshape(num, rows, cols)
    return data

def read_idx_labels(path):
    with open(path, 'rb') as f:
        magic, num = struct.unpack('>II', f.read(8))
        assert magic == 2049
        labels = np.frombuffer(f.read(), dtype=np.uint8)
    return labels

def binarize(image, threshold=128):
    return (image > threshold).astype(np.uint8)

def export_binary_image(image, path):
    binary = binarize(image).flatten()
    with open(path, 'w') as f:
        bits = ''.join(str(b) for b in binary)
        f.write(bits + '\n')

def export_label(label, path):
    with open(path, 'w') as f:
        f.write(str(label) + '\n')

# ==== PROCESS DATASETS ====
def process_dataset(images_path, labels_path, prefix):
    images = read_idx_images(images_path)
    labels = read_idx_labels(labels_path)
    assert len(images) == len(labels)

    for i, (img, label) in enumerate(zip(images, labels)):
        img_file = os.path.join(OUTPUT_DIR, f"{prefix}_image_{i:05d}.mem")
        lbl_file = os.path.join(OUTPUT_DIR, f"{prefix}_label_{i:05d}.txt")
        export_binary_image(img, img_file)
        export_label(label, lbl_file)

    print(f"✅ Exported {len(images)} {prefix} images and labels.")

# ==== MAIN ====
if __name__ == "__main__":
    #process_dataset("train-images-idx3-ubyte", "train-labels-idx1-ubyte", "train")
    process_dataset("t10k-images-idx3-ubyte", "t10k-labels-idx1-ubyte", "test")
