function resultImage = emotion_happy(image, backimg)
    % 배경 제거
    backimage = removeBackground(image); 

    % 크로마키 합성
    resultImage = chromakey(backimage, backimg);
end
