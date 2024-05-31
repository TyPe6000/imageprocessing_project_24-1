function resultImage = emotion_sad(image, backimg)
    % 배경 제거
    backimage = removeBackground(image); 

    % 크로마키 합성
    chromakeyimg = chromakey(backimage, backimg);

    % 파란색을 두드러지게 조정
    blue_chroma = chromakeyimg;
    blue_chroma(:,:,1) = chromakeyimg(:,:,1) * 0.7;
    blue_chroma(:,:,2) = chromakeyimg(:,:,2) * 0.7;
    blue_chroma(:,:,3) = chromakeyimg(:,:,3) * 1.3;

    % 범위를 벗어난 값을 255로 클리핑
    blue_chroma(blue_chroma > 255) = 255;

    resultImage = blue_chroma;
end
