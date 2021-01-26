using System;

namespace lab1
{
    class math
    {
        public const double start = -9.00;
        public const double endt = 2.00;
        public const double step = 0.3;
    }
    class Program
    {
        static void Main(string[] args)
        {
            double y = 0;
            double x = math.start;
            while (x < math.endt)
            {
                if (x < -7)
                {
                    y = Math.Round(Math.Tan(x)/71,2);
                    
                }
                else
                {
                    if ((x >= -7) & (x < 0))
                    {
                        x = Math.Round((double)((x * 100) / 100),2);
                        y = Math.Round(((x * x) / (Math.Exp(0.1 * (-x) * Math.Log(-x)))) * ((Math.Log(2,(-x)) / (x * x * x))),2);
                        //  //Math.Pow(x,0.1*x)
                    }
                    else
                    {
                        if (x >= 0.3)
                        {
                            y = Math.Round((Math.Exp(0.1 * x * Math.Log(x)) / Math.Cos(x) + x),2);
                        }                        
                    }
                }
                Console.WriteLine("x = " +  x + " y = " + y);
                x = x + math.step;
                x = Math.Round((double)((x * 100) / 100), 2);
            }            
        }
    }
}