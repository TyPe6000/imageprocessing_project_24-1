function outputImage = apply_edge_filter(inputImage)
    outputImage = edge(rgb2gray(inputImage), 'Canny');
end
