function resultImage = emotion_surprised(image, backimg)
    % 배경 제거
    backimage = removeBackground(image); 

    % 크로마키 합성
    chromakeyimg = chromakey(backimage, backimg);

    % 흑백 처리
    gray_chroma = rgb2gray(chromakeyimg);

    resultImage = gray_chroma;
end
