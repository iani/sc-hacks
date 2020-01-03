
MocapData.open;

MocapData.data.shape[0,0];

MocapData.data[0,0,0].shape;

z = Array.iota(4, 5);

z = Array.iota(3, 4, 2);




z.slice((1..2), nil);

z;
z[0]

MocapData.data.slice(nil, nil, 0).

MocapData.columns.shape;
MocapData.columns.flop.shape;

MocapData.columns.flop.pc1;


MocapData.columns.flop[0];

//:Prototyping PCA in SC
//NOTE: This requires the matlib quark
//:first read some data
MocapData.open;
//:then do  some calculations on the data
//Work on columns flop because data have the wrong format
MocapData.data.shape.postln; // testing dimensionalities ...
MocapData.columns.shape.postln;
MocapData.dataForPCA.shape.postln;
MocapData.dataForPCA.pc1;
//:pca 1 component ...
MocapData.calcPCA.shape;
//:pca 3 components;
MocapData.calcPCA(3);
MocapData.pca[0]
MocapData.pca[1]
MocapData.pca[2]
MocapData.pca[3]; // nil
//:
MocapData.pca do: { | a | a[..4].round(0.0001).postln };
//:
MocapData.pca[0][..4];
MocapData.pca[2][..4];

