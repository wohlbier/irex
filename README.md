Look at IR of a simple program to see basic blocks.

e.g.,
```
module load cmake-3.17.1-gcc-10.1.0-7x5lm6f
module load llvm-9.0.1-gcc-10.1.0-je4noub
mkdir build
cd build
cmake ../
make
llvm-dis main.0.0.preopt.bc
```

C++:
```
size_t N=1024;
int a = 0;
for (size_t i=0; i<N; i++)
{
    a += rand()%2;
}
```

LLVM:
```
; Function Attrs: noinline norecurse optnone uwtable
define dso_local i32 @main(i32, i8**) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i64, align 8
  %7 = alloca i32, align 4          // allocate a
  %8 = alloca i64, align 8          // allocate i
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  store i64 1024, i64* %6, align 8  // N = 1024
  store i32 0, i32* %7, align 4     // a = 0
  store i64 0, i64* %8, align 8     // i = 0
  br label %9

// for (size_t i=0; i<N; i++)
9:                                                ; preds = %18, %2
  %10 = load i64, i64* %8, align 8  // load i
  %11 = load i64, i64* %6, align 8  // load N
  %12 = icmp ult i64 %10, %11       // i<N (ult = unsigned less than)
  // br i1 <cond>, label <iftrue>, label <iffalse>
  br i1 %12, label %13, label %21

13:                                               ; preds = %9
  %14 = call i32 @rand() #7         // rand()
  %15 = srem i32 %14, 2             // returns remainder of signed division
  %16 = load i32, i32* %7, align 4  // load a
  %17 = add nsw i32 %16, %15        // nsw = 'no signed wrap'
  store i32 %17, i32* %7, align 4   // store into a
  br label %18                      // go to increment block

18:                                               ; preds = %13
  %19 = load i64, i64* %8, align 8  // load i
  %20 = add i64 %19, 1              // increment i
  store i64 %20, i64* %8, align 8   // store i
  br label %9                       // go to conditional block

21:                                               ; preds = %9
  %22 = call dereferenceable(160) %"class.std::__1::basic_ostream"* @_ZNSt3__1lsINS_11char_traitsIcEEEERNS_13basic_ostreamIcT_EES6_PKc(%"class.std::__1::basic_ostream"* dereferenceable(160) @_ZNSt3__14cerrE, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0))
  %23 = load i32, i32* %7, align 4
  %24 = call dereferenceable(160) %"class.std::__1::basic_ostream"* @_ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi(%"class.std::__1::basic_ostream"* %22, i32 %23)
  %25 = call dereferenceable(160) %"class.std::__1::basic_ostream"* @_ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEPFRS3_S4_E(%"class.std::__1::basic_ostream"* %24, %"class.std::__1::basic_ostream"* (%"class.std::__1::basic_ostream"*)* @_ZNSt3__14endlIcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_)
  %26 = load i32, i32* %3, align 4
  ret i32 %26
}
```
