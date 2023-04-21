class test_8 {
    public static void main(String[] args) {

        System.out.println(overload(10));
        System.out.println(overload(10, 20));
        
    }

    static int overload(int a) {
        return a;
    }

    static int overload(int a, int b) {
        return a*b;
    }
}