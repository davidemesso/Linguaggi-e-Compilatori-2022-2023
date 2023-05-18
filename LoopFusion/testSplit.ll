; ModuleID = 'test/loops/Loops.opt.ll'
source_filename = "Loops.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [25 x i8] c"Valori iniziali di c[i]\0A\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str.2 = private unnamed_addr constant [12 x i8] c"\0AHo finito\0A\00", align 1
@.str.3 = private unnamed_addr constant [11 x i8] c"Vettore A\0A\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"\0AVettore B\0A\00", align 1
@.str.5 = private unnamed_addr constant [12 x i8] c"\0AVettore C\0A\00", align 1

; Function Attrs: noinline nounwind sspstrong uwtable
define dso_local void @populate(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  br label %4

4:                                                ; preds = %23, %3
  %.0 = phi i32 [ 0, %3 ], [ %24, %23 ]
  %5 = icmp slt i32 %.0, 10
  br i1 %5, label %6, label %25

6:                                                ; preds = %4
  %7 = sext i32 %.0 to i64
  %8 = getelementptr inbounds i32, ptr %2, i64 %7
  %9 = load i32, ptr %8, align 4
  %10 = mul nsw i32 5, %9
  %11 = sext i32 %.0 to i64
  %12 = getelementptr inbounds i32, ptr %0, i64 %11
  store i32 %10, ptr %12, align 4
  br label %13

13:                                               ; preds = %6
  %14 = sext i32 %.0 to i64
  %15 = getelementptr inbounds i32, ptr %0, i64 %14
  %16 = load i32, ptr %15, align 4
  %17 = sext i32 %.0 to i64
  %18 = getelementptr inbounds i32, ptr %2, i64 %17
  %19 = load i32, ptr %18, align 4
  %20 = add nsw i32 %16, %19
  %21 = sext i32 %.0 to i64
  %22 = getelementptr inbounds i32, ptr %1, i64 %21
  store i32 %20, ptr %22, align 4
  br label %23

23:                                               ; preds = %13
  %24 = add nsw i32 %.0, 1
  br label %4, !llvm.loop !6

25:                                               ; preds = %4
  br label %26

26:                                               ; preds = %28, %25
  %.1 = phi i32 [ 0, %25 ], [ %29, %28 ]
  %27 = icmp slt i32 %.0, 10
  br i1 %27, label %.split, label %30

.split:                                           ; preds = %26
  br label %28

28:                                               ; preds = %.split
  %29 = add nsw i32 %.0, 1
  br label %26, !llvm.loop !8

30:                                               ; preds = %26
  ret void
}

; Function Attrs: noinline nounwind sspstrong uwtable
define dso_local i32 @main() #0 {
  %1 = alloca [10 x i32], align 16
  %2 = alloca [10 x i32], align 16
  %3 = alloca [10 x i32], align 16
  %4 = call i32 (ptr, ...) @printf(ptr noundef @.str)
  br label %5

5:                                                ; preds = %14, %0
  %.01 = phi i32 [ 0, %0 ], [ %15, %14 ]
  %6 = icmp slt i32 %.01, 10
  br i1 %6, label %7, label %16

7:                                                ; preds = %5
  %8 = sext i32 %.01 to i64
  %9 = getelementptr inbounds [10 x i32], ptr %3, i64 0, i64 %8
  store i32 1, ptr %9, align 4
  %10 = sext i32 %.01 to i64
  %11 = getelementptr inbounds [10 x i32], ptr %3, i64 0, i64 %10
  %12 = load i32, ptr %11, align 4
  %13 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %12)
  br label %14

14:                                               ; preds = %7
  %15 = add nsw i32 %.01, 1
  br label %5, !llvm.loop !9

16:                                               ; preds = %5
  %17 = getelementptr inbounds [10 x i32], ptr %1, i64 0, i64 0
  %18 = getelementptr inbounds [10 x i32], ptr %2, i64 0, i64 0
  %19 = getelementptr inbounds [10 x i32], ptr %3, i64 0, i64 0
  call void @populate(ptr noundef %17, ptr noundef %18, ptr noundef %19)
  %20 = call i32 (ptr, ...) @printf(ptr noundef @.str.2)
  %21 = call i32 (ptr, ...) @printf(ptr noundef @.str.3)
  br label %22

22:                                               ; preds = %29, %16
  %.02 = phi i32 [ 0, %16 ], [ %30, %29 ]
  %23 = icmp slt i32 %.02, 10
  br i1 %23, label %24, label %31

24:                                               ; preds = %22
  %25 = sext i32 %.02 to i64
  %26 = getelementptr inbounds [10 x i32], ptr %1, i64 0, i64 %25
  %27 = load i32, ptr %26, align 4
  %28 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %27)
  br label %29

29:                                               ; preds = %24
  %30 = add nsw i32 %.02, 1
  br label %22, !llvm.loop !10

31:                                               ; preds = %22
  %32 = call i32 (ptr, ...) @printf(ptr noundef @.str.4)
  br label %33

33:                                               ; preds = %40, %31
  %.03 = phi i32 [ 0, %31 ], [ %41, %40 ]
  %34 = icmp slt i32 %.03, 10
  br i1 %34, label %35, label %42

35:                                               ; preds = %33
  %36 = sext i32 %.03 to i64
  %37 = getelementptr inbounds [10 x i32], ptr %2, i64 0, i64 %36
  %38 = load i32, ptr %37, align 4
  %39 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %38)
  br label %40

40:                                               ; preds = %35
  %41 = add nsw i32 %.03, 1
  br label %33, !llvm.loop !11

42:                                               ; preds = %33
  %43 = call i32 (ptr, ...) @printf(ptr noundef @.str.5)
  br label %44

44:                                               ; preds = %51, %42
  %.0 = phi i32 [ 0, %42 ], [ %52, %51 ]
  %45 = icmp slt i32 %.0, 10
  br i1 %45, label %46, label %53

46:                                               ; preds = %44
  %47 = sext i32 %.0 to i64
  %48 = getelementptr inbounds [10 x i32], ptr %3, i64 0, i64 %47
  %49 = load i32, ptr %48, align 4
  %50 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %49)
  br label %51

51:                                               ; preds = %46
  %52 = add nsw i32 %.0, 1
  br label %44, !llvm.loop !12

53:                                               ; preds = %44
  ret i32 0
}

declare i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 15.0.7"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = distinct !{!12, !7}
