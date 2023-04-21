public class QuickSort {

    int x = 5;
    int y = 10;
    int z = 20;
    int a = z + 50;

    // QuickSort(int a, int b) {
    //     this.x = a;
    //     this.y = b;
    // }

    public void print_members() {
        System.out.println(this.x);
        System.out.println(this.y);
        System.out.println(this.a);
        System.out.println(this.z);
    }

    public int f(int x){
        x = 20;
        return x;
    }

    public static void main(String[] args) {
        QuickSort obj = new QuickSort();
        // QuickSort obj2 = new QuickSort();
        
        // obj.print_members();
        // obj2.print_members();
        // int a, b;
        // int woah[][] = new int[a][b];
        // obj.x = 20;
        // obj.print_members();
        // obj.x = obj.x * 10;
        // obj.print_members();
        // System.out.println(obj.x);
        // obj.print_members();

        // System.out.println(obj.f(obj.x + 69));
        obj.print_members();
    }
}