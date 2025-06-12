# ✅ Step 1: Import libraries
import torch
import torch.nn as nn
import torchvision
import torchvision.transforms as transforms
import matplotlib.pyplot as plt
import numpy as np

# ✅ Step 2: Define the model architecture
class BNN(nn.Module):
    def __init__(self):
        super(BNN, self).__init__()
        self.fc1 = nn.Linear(784, 256)
        self.bn1 = nn.BatchNorm1d(256)
        self.fc2 = nn.Linear(256, 10)

    def forward(self, x):
        x = torch.sign(self.bn1(self.fc1(x)))  # Binarized activation
        x = self.fc2(x)
        return x

# ✅ Step 3: Load MNIST test data
transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Lambda(lambda x: x.view(-1))
])
test_dataset = torchvision.datasets.MNIST(root='./data', train=False, download=True, transform=transform)

# ✅ Step 4: Load pretrained model
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = BNN().to(device)
model.load_state_dict(torch.load("best_bnn_model.pth", map_location=device))
model.eval()

# ✅ Step 5: Select a test image
image, label = test_dataset[0]
flat_image = image.view(1, -1).to(device)

# ✅ Step 6: Save test_input_fc1.mem (784-bit binary input)
binary_fc1_input = (flat_image > 0).int().cpu().numpy().flatten()
with open("test_input_fc1.mem", "w") as f:
    f.write(''.join(str(bit) for bit in binary_fc1_input) + '\n')

# ✅ Step 7: Compute FC1 output and save as test_input_fc2.mem
with torch.no_grad():
    fc1_out = torch.sign(model.bn1(model.fc1(flat_image)))  # Values: -1 or +1
binary_fc1_output = ((fc1_out + 1) / 2).int().cpu().numpy().flatten()  # Map {-1,1} to {0,1}
with open("test_input_fc2.mem", "w") as f:
    f.write(''.join(str(bit) for bit in binary_fc1_output) + '\n')

# # ✅ Step 8: Export FC1 weights (256x784, binarized) as fc1_weights.mem
# fc1_weights = torch.sign(model.fc1.weight.detach()).cpu().numpy()
# fc1_weights_bin = ((fc1_weights + 1) / 2).astype(int)
# with open("fc1_weights.mem", "w") as f:
#     for row in fc1_weights_bin:
#         f.write(''.join(str(bit) for bit in row) + '\n')

# # ✅ Step 9: Export FC2 weights (10x256, binarized) as fc2_weights.mem
# fc2_weights = torch.sign(model.fc2.weight.detach()).cpu().numpy()
# fc2_weights_bin = ((fc2_weights + 1) / 2).astype(int)
# with open("fc2_weights.mem", "w") as f:
#     for row in fc2_weights_bin:
#         f.write(''.join(str(bit) for bit in row) + '\n')


# ✅ Step 10: Show image and label
plt.imshow(image.view(28, 28), cmap='gray')
plt.title(f"Label: {label}")
plt.axis('off')
plt.show()

print("✅ Saved test_input_fc1.mem (image) and test_input_fc2.mem (FC1 output)")
print("✅ Saved fc1_weights.mem and fc2_weights.mem")
print("Ground-truth label:", label)
