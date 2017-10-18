a = FileItemList.loadAS("test");
//:
a add: 123;
//:
b = FileItemList.loadAS("test");
//:
b.array;
//:
FileItemList.loadAS("test").array;