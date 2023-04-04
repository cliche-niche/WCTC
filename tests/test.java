class test_10 {
    // int A[] = new int[10];
    int f;
    int j;

    int func(int a) {
        f = 10;
        int A[] = new int[10];

        A[1] = 20;
        A[2] = 30;
        A[3] = A[5] + A[6];


        this.f = 10;        //*(this + 0) = 10;
        // a = this.j + this.f;
        func(this.j + this.f + A[3]);
        /*
            t1 = this;
            t2 = t1 + 0;
            *(t2) = 10
         */
        return 0;
    }

    public static void main(String[] args) {
        test_10 obj1 = new test_10();
        test_10 obj2 = new test_10();
    }
}