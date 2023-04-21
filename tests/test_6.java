public class test_6 {
    static int sum(int arr[], int size) {
        int result = 0;
        for (int i = 0; i < size; i++) {
            result += arr[i];
        }
        return result;
    }

    public static void main(String[] args) {
        int[] arr= new int[5];
		
		for(int i = 0; i < 5; i++){
			arr[i] = i * i;
		}
		
        int result = sum(arr, 5);
        System.out.println(result);
    }
}