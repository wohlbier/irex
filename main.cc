#include <cstdlib>
#include <iostream>

int main (int argc, char *argv[])
{
    size_t N=1024;
    int a = 0;
    for (size_t i=0; i<N; i++)
    {
        a += rand()%2;
    }
    std::cerr << "a: " << a << std::endl;
}
