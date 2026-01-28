// 인스턴스화 가능
import '4_2_final_modifier.dart';

Parent parent = Parent();

// final class는 상속 불가능
class Child1 extends Parent {}

// implement 불가능
class Child2 implements Pattern {}
