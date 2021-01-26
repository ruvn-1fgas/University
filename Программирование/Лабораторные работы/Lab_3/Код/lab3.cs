using System;

namespace lab_3
{
    class Program
    {
        static double a;
        static double b;
        static int n;
        static double s;
        static int lineCh;
        static void Main(string[] args)
        {
            while(true)
                {
                ConsoleKeyInfo key = Console.ReadKey();
                Console.Clear();
                switch(key.Key)
                {
                    case ConsoleKey.Enter:
                        printmenu(lineCh);
                        break;
                    case ConsoleKey.DownArrow:
                        lineCh = lineCh + 1;
                        if (lineCh > 6)
                        {
                            lineCh = 0;
                        }
                        printmenu(lineCh);
                        break;
                    case ConsoleKey.RightArrow:
                        switch(lineCh)
                        {
                            case 0:
                                inf();
                                break;
                            case 1:
                                interval();
                                break;
                            case 2:
                                pl();
                                break;
                            case 3:
                                an();
                                break;
                            case 4:
                                abpogr();
                                break;
                            case 5:
                                otnpogr();
                                break;
                            case 6:
                                System.Environment.Exit(0);
                                break;
                        }
                        break;
                    case ConsoleKey.UpArrow:
                        lineCh--;
                        if (lineCh < 0)
                        {
                            lineCh = 6;
                        }
                        printmenu(lineCh);
                        break;
                }
                }
        }
        public static double f(double x)
        {
            double f_ = x * x * x + 2 * x * x + x + 10;
            return f_;
        }
        public static double f1(double x)
        {
            double f1_ = (x * (3 * x * x * x + 8 * x * x + 6 * x + 120)) / 12;
            return f1_;
        }
        public static void inf()
        {
            Console.WriteLine("1.Реализовать программу вычисления площади фигуры, ограниченной кривой 1 * x^3 + 2 * x^2 + 1 * x + 10 и осью ОХ(в положительной части по оси OY).");
            Console.WriteLine("2.Вычисление определенного интеграла должно выполняться численно, с применением метода трапеций.");
            Console.WriteLine("3.Пределы интегрирования вводятся пользователем.");
            Console.WriteLine("4.Взаимодействие с пользователем должно осуществляться посредстов case menu.");
            Console.WriteLine("5.Требуется реализовать возможность оценки погрешности полученного результата.");
            Console.WriteLine("6.Необходимо использовать процедуры и функции там, где это целесообразно");
        }
        static void interval()
        {
            do
            {
                Console.Clear();
                Console.WriteLine("Введите левую границу интегрирования a >= -2,8675 ");
                a = Convert.ToDouble(Console.ReadLine());            
            }while(a < -2.8675);

            {
                Console.Clear();
                Console.WriteLine("Введите левую границу интегрирования b > a ");
                b = Convert.ToDouble(Console.ReadLine());
            } while (b <= a) ;
            do
            {
                Console.Clear();
                Console.WriteLine("Введите кол-во разбиений от 20 до 250 n = ");
                n = Convert.ToInt32(Console.ReadLine());
            } while ((n < 20) | (n > 250));
            Console.Clear();
            Console.WriteLine("Границы интегрирования: ("+ Math.Round(a,3)+ ";"+ Math.Round(b,3)+ ")"+ " Кол-во разбиений: "+ n);
        }
        public static void pl()
        {
            double h = (b - a) / n;
            s = (f(a) + f(b)) / 2;
            for (int i = 1; i <= n - 1; i++)
            {
                s = s + f(a + i * h);
            }
            s = s * h;
            Console.WriteLine("Площадь = " + Math.Round(s,5));
        }
        public static void an()
        {
            double y = f1(b) - f1(a);
            Console.WriteLine("Аналитическое значение = " + Math.Round(y, 5));
        }
        public static void abpogr()
        {
            double y = f1(b) - f1(a);
            Console.WriteLine("Абсолютная погрешность = " + Math.Round(Math.Abs(y-s), 5));
        }
        public static void otnpogr()
        {
            double y = f1(b) - f1(a);
            Console.WriteLine("Относительная погрешность = " + Math.Round(Math.Abs(y - s)/y, 5));
        }
        public static void printmenu(int indexLine)
        {
            string[] menu = new string[7];
            menu[0] = "Информация о задании";
            menu[1] = "Границы интегрирования и кол-во разбиений";
            menu[2] = "Площадь";
            menu[3] = "Аналитическое значение";
            menu[4] = "Абсолютная погрешность";
            menu[5] = "Относительная погрешность";
            menu[6] = "Выход";
            for (int i = 0; i <= 6; i++)
            {
                if (i == indexLine)
                {
                    Console.ForegroundColor = ConsoleColor.Green;
                }
                Console.WriteLine(menu[i]);
                Console.ResetColor(); 
            }
        }
    }
}
