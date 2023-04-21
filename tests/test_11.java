class Shape {
    int side = 5;

    Shape(int s) {
        this.side = s;
    }

    Shape() { ; }

    int computeArea(){
        return this.side * this.side;
    }

    public static void main(String[] args) {
        Shape s1 = new Shape(15);
        Shape s2 = new Shape();

        System.out.println(s1.computeArea());
        System.out.println(s2.computeArea());
    }
}