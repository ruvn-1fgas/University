using System;

namespace lab2
{
    class Program
    {
        static void Main(string[] args)
        {
            int N=0;
            int[] a = new int[100];
            do
            {
                Console.Clear();
                Console.WriteLine("Введите кол-во элементов массива");
               N = Convert.ToInt32(Console.ReadLine());
            } while ((N < 1) | (N > 100));
            Console.Clear();
            Console.WriteLine("Число элементов в массиве " + N);
            for (int i = 0; i < N; i++)
            {
                Console.WriteLine("Введите " + (i+1) + "-ый элемент массива");
                a[i] = Convert.ToInt32(Console.ReadLine());
            }
            Console.Clear();
            Console.WriteLine("Число элементов в массиве " + N);
            Console.WriteLine();
            Console.Write("Массив [ ");
            for (int i = 0; i < N; i++)
            {
                Console.Write(a[i] + " ");
            }
            Console.Write("]");
            int min = 0;
            int max = 0;
            for (int i = 1; i < N; i++)
            {
                if (a[i] <= a[min])
                {
                    min = i;
                }
                else
                {
                    if (a[i] >= a[max])
                        {
                        max = i;
                    }
                }
            }
            Console.WriteLine();
            Console.WriteLine("Макс. элемент массива = " + a[max] + "         " + "Мин. элемент массива = " + a[min]);
            if (min > max)
            {
                int i;
                i = min;
                min = max;
                max = min;
            }
            int sum = 0;
            for (int i = (min + 1); i < (max); i++)
            {
                sum = sum + a[i];
            }
            Console.WriteLine("Сумма = " + sum);
        }
    }
}
