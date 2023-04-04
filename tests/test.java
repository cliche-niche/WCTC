public class Example1 {
		int x;
        double y;

        Example1(int x, double y) {
            this.x = x;
            this.y = y;
        }

        public static void main(String[] args /*so that we can compile with javac*/) {
            Example1 a = new Example1(2,3.14);
            System.out.println(a.x);
            System.out.println(a.y);
        }
}

// class ab{
//     int y;
//     int c;
// }

// class cd{
//     ab d;
//     int y;
// }

// class ace{
//     // cd lmao;

//     public void func() {
//         // cd a[][][] = new cd[2][4][3];
//     }
// }