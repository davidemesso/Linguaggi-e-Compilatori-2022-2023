; ModuleID = 'Loops.opt.bc'
source_filename = "Loops.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1

; Function Attrs: noinline nounwind sspstrong uwtable
define dso_local void @populate(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  %4 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef 10)
  br label %5

5:                                                ; preds = %29, %3
  %.0 = phi i32 [ 0, %3 ], [ %30, %29 ]
  %6 = icmp slt i32 %.0, 100
  br i1 %6, label %7, label %31

7:                                                ; preds = %5
  %8 = sext i32 %.0 to i64
  %9 = getelementptr inbounds i32, ptr %2, i64 %8
  %10 = load i32, ptr %9, align 4
  %11 = mul nsw i32 5, %10
  %12 = sext i32 %.0 to i64
  %13 = getelementptr inbounds i32, ptr %0, i64 %12
  store i32 %11, ptr %13, align 4
  br label %14

14:                                               ; preds = %26, %7
  %.1 = phi i32 [ 0, %7 ], [ %27, %26 ]
  %15 = icmp slt i32 %.1, 100
  br i1 %15, label %16, label %28

16:                                               ; preds = %14
  %17 = sext i32 %.1 to i64
  %18 = getelementptr inbounds i32, ptr %0, i64 %17
  %19 = load i32, ptr %18, align 4
  %20 = sext i32 %.1 to i64
  %21 = getelementptr inbounds i32, ptr %2, i64 %20
  %22 = load i32, ptr %21, align 4
  %23 = add nsw i32 %19, %22
  %24 = sext i32 %.1 to i64
  %25 = getelementptr inbounds i32, ptr %1, i64 %24
  store i32 %23, ptr %25, align 4
  br label %26

26:                                               ; preds = %16
  %27 = add nsw i32 %.1, 1
  br label %14, !llvm.loop !6

28:                                               ; preds = %14
  br label %29

29:                                               ; preds = %28
  %30 = add nsw i32 %.1, 1
  br label %5, !llvm.loop !8

31:                                               ; preds = %5
  br label %32

32:                                               ; preds = %44, %31
  %.2 = phi i32 [ 0, %31 ], [ %45, %44 ]
  %33 = icmp slt i32 %.2, 100
  br i1 %33, label %34, label %46

34:                                               ; preds = %32
  %35 = sext i32 %.2 to i64
  %36 = getelementptr inbounds i32, ptr %1, i64 %35
  %37 = load i32, ptr %36, align 4
  %38 = sext i32 %.2 to i64
  %39 = getelementptr inbounds i32, ptr %0, i64 %38
  %40 = load i32, ptr %39, align 4
  %41 = add nsw i32 %37, %40
  %42 = sext i32 %.2 to i64
  %43 = getelementptr inbounds i32, ptr %2, i64 %42
  store i32 %41, ptr %43, align 4
  br label %44

44:                                               ; preds = %34
  %45 = add nsw i32 %.2, 1
  br label %32, !llvm.loop !9

46:                                               ; preds = %32
  ret void
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
