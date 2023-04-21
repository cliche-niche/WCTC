public class test_1{
    static int max(int a, int b) { return (a > b) ? a : b; }
 
    // Returns the maximum value that can
    // be put in a knapsack of capacity W
    static int knapSack(int W, int wt[], int val[], int n)
    {
        // Base Case
        if (n == 0 || W == 0)
            return 0;
 
        // If weight of the nth item is more
        // than Knapsack capacity W, then
        // this item cannot be included in the optimal solution
        if (wt[n - 1] > W)
            return knapSack(W, wt, val, n - 1);
 
        // Return the maximum of two cases:
        // (1) nth item included
        // (2) not included
        else
            return max(val[n - 1] + knapSack(W - wt[n - 1], wt, val, n - 1),
                       knapSack(W, wt, val, n - 1));
    }
 
    // Driver program to test above function
    public static void main(String args[])
    {
        int val[] = new int[3];
        val[0] = 60;
        val[1] = 100;
        val[2] = 120;

        int wt[] = new int[3];
        wt[0] = 10;
        wt[1] = 20;
        wt[2] = 30; 

        int W = 50;
        int n = 3;
        System.out.println(knapSack(W, wt, val, n));
    }
}

