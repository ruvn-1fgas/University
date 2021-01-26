using System;

namespace lab2_2
{
    class Program
    {
        static void Main(string[] args)
        {
            int ss;
            Console.WriteLine("Введите строку");
            string s = Console.ReadLine();
            ss = s.Length;
            bool flag = true;
            for (int i = 0; i < ss / 2; i++)
            {
                if (Char.ToLower(s[i])!= Char.ToLower(s[ss - i - 1]))
                {
                    Console.WriteLine("Строка не является палиндромом");
                    flag = false;
                    break;
                }
                if (flag)
                {
                    Console.WriteLine("Строка является палиндромом");
                    break;
                }    
            }
        }
    }
}
