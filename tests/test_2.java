public class test_2 {
    static int RecursiveFibonacci(int a, int b, int n) {
        if(n == 1) return b;

        return RecursiveFibonacci(b, a + b, n-1);
    }

    public static void main(String[] args) {
        System.out.println(RecursiveFibonacci(0, 1, 10));
    }
}