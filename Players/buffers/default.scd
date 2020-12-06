/*
Load all sound files contained in the sounds directory of the SuperCollider application.
*/
(Platform.resourceDir +/+ "sounds/").loadBuffers;

Buffer.all;

Buffer.allNames.sort;

(Platform.resourceDir +/+ "sounds/*").pathMatch

