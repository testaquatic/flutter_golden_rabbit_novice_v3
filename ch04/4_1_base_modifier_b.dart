import '4_1_base_modifier.dart';

// 인스턴스화 가능
Parent parent = Parent();

// 가능
base class Child extends Parent {}

class Child2 extends Parent {}
// 에러 발생: base, final, sealed 중 하나가 필요함

class Child3 implements Parent {}

// 에러 발생: base, final, sealed 중 하나가 필요함
