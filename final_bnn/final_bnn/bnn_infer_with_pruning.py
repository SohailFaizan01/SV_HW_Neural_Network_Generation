import numpy as np

def load_weight_matrix_from_mem(filename, shape):
    """
    Loads a weight matrix from a binary .mem file, reading 2 bits at a time.
    Binary pairs are interpreted as:
        '00' → -1
        '01' →  1
        '10' →  0 (no connection)
    Args:
        filename (str): Path to the .mem file containing binary weight pairs.
        shape (tuple): Desired shape of the weight matrix, e.g. (784, 512).

    Returns:
        np.ndarray: The weight matrix with shape `shape`, and values in {-1, 0, 1}.
    """
    with open(filename, 'r') as f:
        bits = ''.join(f.read().split())  # remove whitespace and line breaks

    total_elements = shape[0] * shape[1]
    if len(bits) != total_elements * 2:
        raise ValueError(f"Expected {total_elements * 2} bits for shape {shape}, but got {len(bits)}.")

    values = []
    for i in range(0, len(bits), 2):
        pair = bits[i:i+2]
        if pair == '00':
            values.append(-1)
        elif pair == '01':
            values.append(1)
        elif pair == '10':
            values.append(0)
        else:
            raise ValueError(f"Invalid bit pair encountered: '{pair}' at position {i}")

    return np.array(values, dtype=np.int8).reshape(shape)

def load_biases_from_mem_int(filename):
    """
    Load signed 16-bit integer biases from a .mem file where each line contains a 4-character hex string.
    Returns a 1D numpy array of dtype int16.
    """
    biases = []
    with open(filename, 'r') as f:
        for line in f:
            hex_str = line.strip()
            if hex_str:
                val = int(hex_str, 16)
                # Two's complement
                if val >= 0x8000:
                    val -= 0x10000
                biases.append(val)
    return np.array(biases, dtype=np.int16)

def sign(x):
    return np.where(x > 0, 1, -1)

def convert_file_to_np_array(filename):
    try:
        with open(filename, 'r') as file:
            # Read the entire file into a string
            binary_data = file.read().replace("\n", "")  # Remove any newline characters
            
            # Ensure we have exactly 784 * 8 bits (or 6272 characters)
            if len(binary_data) != 784 * 8:
                raise ValueError("The file doesn't contain exactly 784 8-bit values")
            
            # Split the string into 8-bit chunks and convert each chunk to an integer
            byte_values = np.array([int(binary_data[i:i+8], 2) for i in range(0, len(binary_data), 8)], dtype=np.uint8)
            
            return byte_values
        
    except FileNotFoundError:
        print(f"File '{filename}' not found.")
        return np.array([])
    except ValueError as e:
        print(e)
        return np.array([])

def read_label_file(filepath):
    with open(filepath, 'r') as f:
        label_str = f.read().strip()
    return int(label_str)

def bnn_layer(input_vector, weight_matrix, bias_vector):
    """
    Simulate a Binary Neural Network (BNN):
    output = weight_matrix @ input_vector + bias_vector

    Args:
        input_vector (np.ndarray): 1D array, shape (input_size,), typically binary or integer.
        weight_matrix (np.ndarray): 2D array, shape (output_size, input_size), binary or integer.
        bias_vector (np.ndarray): 1D array, shape (output_size,), integer biases.

    Returns:
        np.ndarray: 1D array, shape (output_size,), layer output values (integers).
    """

    # Check shapes for sanity
    if weight_matrix.shape[1] != input_vector.shape[0]:
        raise ValueError(f"Weight matrix input dimension {weight_matrix.shape[1]} "
                         f"does not match input vector size {input_vector.shape[0]}")

    if weight_matrix.shape[0] != bias_vector.shape[0]:
        raise ValueError(f"Weight matrix output dimension {weight_matrix.shape[0]} "
                         f"does not match bias vector size {bias_vector.shape[0]}")

    # Perform matrix multiplication and add bias
    output = np.dot(weight_matrix, input_vector) + bias_vector

    return output

if __name__ == "__main__":
    test_folder = "pruned_weights"

    fc1_weights = load_weight_matrix_from_mem(f"{test_folder}/fc1_folded_weight_2bit.txt", shape=(512, 784))
    fc2_weights = load_weight_matrix_from_mem(f"{test_folder}/fc2_folded_weight_2bit.txt", shape=(256, 512))
    fc3_weights = load_weight_matrix_from_mem(f"{test_folder}/fc3_weight_2bit.txt", shape=(10, 256))
    bias1 = load_biases_from_mem_int(f"{test_folder}/fc1_folded_bias_fixed.mem")
    bias2 = load_biases_from_mem_int(f"{test_folder}/fc2_folded_bias_fixed.mem")
    bias3 = load_biases_from_mem_int(f"{test_folder}/fc3_bias_fixed.mem")

    correct = 0
    num_tests = 10000

    for i in range(num_tests):
        image_filename = f"grayscale_mnist_t10k_mem/image_{i}.mem"
        label_filename = f"MNIST_testing_binary_and_label/test_label_{i}.txt"
        image = convert_file_to_np_array(image_filename)
        expected_label = read_label_file(label_filename)

        #Inference
        output_1 = bnn_layer(image, fc1_weights, bias1)
        output_1 = sign(output_1)
        output_2 = bnn_layer(output_1, fc2_weights, bias2)
        output_2 = sign(output_2)
        output_3 = bnn_layer(output_2, fc3_weights, bias3)

        predicted_label = np.argmax(output_3)
        if expected_label == predicted_label:
            correct += 1
        #else:
            #print(f"Incorrect label for test {i}; Expected {expected_label}, got {predicted_label}")
    accuracy = (correct / num_tests) * 100
    print(f"Accuracy: {accuracy:.2f}")
