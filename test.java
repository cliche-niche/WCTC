public class test {
    int t = 5;
    int a = b = c = d;
}
public class BubbleSort {
    public static void main(final String[] args) {
        int ttic = 5;
        int a = 5;
        if(a < b == a){
            ;
        }
        int a = 5;

    }
}

public class BubbleSort {
    public static void main(final String[] args) {
        int n = 10, c, d, swap;

        final int array[] = new int[] { 23, 1, 78, 45, 46, 90, 2, 12, 75, 0 };

        for (c = 0; c < (n - 1); c++) {
            for (d = 0; d < n - c - 1; d++) {
                if (array[d] > array[d + 1]) /* For descending order use < */
                {
                    swap = array[d];
                    array[d] = array[d + 1];
                    array[d + 1] = swap;
                }
            }
        }
        System.out.println();
        for (c = 0; c < n; c++)
            System.out.println(array[c]);
    }
}