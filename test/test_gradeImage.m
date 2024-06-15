% Load packages
pkg load image;

% Test input file paths
goodFile = "example_good.png";
midFile = "example_mid.png";
badFile = "example_bad.png";
midFile2 = "example2_mid.png";
realtesta = "realtest_a.png";
realtestb = "realtest_b.png";
newtesta = "newtest_a.png";
newtestb = "newtest_b.png";

% Test output file paths
goodOut = "out_good.png";
midOut = "out_mid.png";
badOut = "out_bad.png";
midOut2 = "out_mid2.png";
realOuta = "out_real_a.png";
realOutb = "out_real_b.png";
newOuta = "out_new_a.png";
newOutb = "out_new_b.png";

% Read in test images
Igood = imread(goodFile);
Imid = imread(midFile);
Ibad = imread(badFile);
Imid2 = imread(midFile2);
Ireala = imread(realtesta);
Irealb = imread(realtestb);
Inewa = imread(newtesta);
Inewb = imread(newtestb);

% Clean test images
Igood = cleanImage(Igood, "A", 1);
Imid = cleanImage(Imid, "A", 2);
Ibad = cleanImage(Ibad, "A", 3);
Imid2 = cleanImage(Imid2, "B", 4);
Ireala = cleanImage(Ireala, "A", 5);
Irealb = cleanImage(Irealb, "B", 6);
Inewa = cleanImage(Inewa, "A", 7);
Inewb = cleanImage(Inewb, "B", 8);

if isnan(Ibad);
	clear Ibad;
end

% Grade test images
##goodGrade = gradeImage(Igood);
##midGrade = gradeImage(Imid);
##mid2Grade = gradeImage(Imid2);

% Write processed images
imwrite(Igood, goodOut);
imwrite(Imid, midOut);
imwrite(Imid2, midOut2);
imwrite(Ireala, realOuta);
imwrite(Irealb, realOutb);
imwrite(Inewa, newOuta);
imwrite(Inewb, newOutb);

% Unload packages
pkg unload image;
