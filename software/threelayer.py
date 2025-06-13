import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torchvision import datasets, transforms
from torch.utils.data import DataLoader

class BinaryLinear(nn.Linear):
    def __init__(self, in_features, out_features, bias=True):
        super().__init__(in_features, out_features, bias)
        self.org = self.weight.data.clone()

    def forward(self, input):
        bin_weight = self.weight.sign()
        return F.linear(input, bin_weight, self.bias)

class BinaryActivation(torch.autograd.Function):
    @staticmethod
    def forward(ctx, input):
        return input.sign()

    @staticmethod
    def backward(ctx, grad_output):
        return grad_output

class BNN(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc1 = BinaryLinear(784, 512)
        self.bn1 = nn.BatchNorm1d(512)
        self.fc2 = BinaryLinear(512, 512)
        self.bn2 = nn.BatchNorm1d(512)
        self.fc3 = BinaryLinear(512, 512)
        self.bn3 = nn.BatchNorm1d(512)
        self.fc4 = nn.Linear(512, 10)

    def forward(self, x):
        x = x.view(-1, 28*28)
        x = self.fc1(x); x = self.bn1(x); x = BinaryActivation.apply(x)
        x = self.fc2(x); x = self.bn2(x); x = BinaryActivation.apply(x)
        x = self.fc3(x); x = self.bn3(x); x = BinaryActivation.apply(x)
        x = self.fc4(x)
        return F.log_softmax(x, dim=1)

def save_binarized_weights(tensor, filename):
    bin_weight = ((tensor.sign() + 1) / 2).int().cpu().numpy().flatten()
    with open(filename, 'w') as f:
        for bit in bin_weight:
            f.write(f"{bit}\n")

def main():
    # === 二值图像 transform ===
    transform = transforms.Compose([
        transforms.ToTensor(),
        transforms.Lambda(lambda x: (x > 0.5).float() * 2 - 1)  # Binary ±1
    ])

    train_loader = DataLoader(datasets.MNIST('./data', train=True, download=True, transform=transform), batch_size=64, shuffle=True)
    test_loader = DataLoader(datasets.MNIST('./data', train=False, download=True, transform=transform), batch_size=1000)

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model = BNN().to(device)
    optimizer = optim.Adam(model.parameters(), lr=0.001)
    criterion = nn.NLLLoss()

    for epoch in range(1, 20):
        model.train()
        for data, target in train_loader:
            data, target = data.to(device), target.to(device)
            optimizer.zero_grad()
            output = model(data)
            loss = criterion(output, target)
            loss.backward()

            for p in model.parameters():
                if hasattr(p, 'org'):
                    p.data.copy_(p.org)
            optimizer.step()
            for p in model.parameters():
                if hasattr(p, 'org'):
                    p.org.copy_(p.data.clamp_(-1, 1))

        model.eval()
        correct = 0
        with torch.no_grad():
            for data, target in test_loader:
                data, target = data.to(device), target.to(device)
                output = model(data)
                pred = output.argmax(dim=1)
                correct += (pred == target).sum().item()
        acc = 100. * correct / len(test_loader.dataset)
        print(f"Epoch {epoch}: Test Accuracy = {acc:.2f}%")

        save_binarized_weights(model.fc1.weight.data, f"fc1_epoch{epoch}.mem")
        save_binarized_weights(model.fc2.weight.data, f"fc2_epoch{epoch}.mem")
        save_binarized_weights(model.fc3.weight.data, f"fc3_epoch{epoch}.mem")

if __name__ == '__main__':
    main()
