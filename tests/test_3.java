public class test_3 {
    public static void main(String[] args) {
        int n = 100; // find the 100th prime number
        int count = 1; // start at 1 because 2 is the first prime number
        int num = 3; // start checking for primes at 3

        while (count < n) {
            boolean isPrime = true;

            // check if num is divisible by any odd number up to its square root
            for (int i = 3; i <= num; i += 2) {
                if(i * i > num) break;
                if ((num / i) * i == num) {
                    isPrime = false;
                    break;
                }
            }

            if (isPrime) {
                count++;
            }

            num += 2; // check the next odd number
        }

        int prime_num = num - 2;
		System.out.println(prime_num);
    }
}