public class test_4 {
    int func_calls = 0;

    int fib(int n) {
        int memo[] = new int[n+1];
        for(int i = 0; i <= n; i++){
            memo[i] = 0;
        }
        return fibHelper(n, memo);
    }

    int fibHelper(int n, int memo[]) {
        this.func_calls++;
        if (n == 0 || n == 1) {
            return n;
        }

        if (memo[n] != 0) {
            return memo[n];
        }

        memo[n] = fibHelper(n-1, memo) + fibHelper(n-2, memo);
        return memo[n];
    }

    public static void main(String[] args) {
        test_4 obj = new test_4();

        int n = 10;
        int result = obj.fib(n);
        System.out.println(result);
        System.out.println(obj.func_calls);
    }
}
