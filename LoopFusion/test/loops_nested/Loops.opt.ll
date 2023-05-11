; ModuleID = 'Loops.opt.bc'
source_filename = "Loops.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind sspstrong uwtable
define dso_local void @populate(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  br label %4

4:                                                ; preds = %28, %3
  %.0 = phi i32 [ 0, %3 ], [ %29, %28 ]
  %5 = icmp slt i32 %.0, 100
  br i1 %5, label %6, label %30

6:                                                ; preds = %4
  %7 = sext i32 %.0 to i64
  %8 = getelementptr inbounds i32, ptr %2, i64 %7
  %9 = load i32, ptr %8, align 4
  %10 = mul nsw i32 5, %9
  %11 = sext i32 %.0 to i64
  %12 = getelementptr inbounds i32, ptr %0, i64 %11
  store i32 %10, ptr %12, align 4
  br label %13

13:                                               ; preds = %25, %6
  %.1 = phi i32 [ 0, %6 ], [ %26, %25 ]
  %14 = icmp slt i32 %.1, 100
  br i1 %14, label %15, label %27

15:                                               ; preds = %13
  %16 = sext i32 %.1 to i64
  %17 = getelementptr inbounds i32, ptr %0, i64 %16
  %18 = load i32, ptr %17, align 4
  %19 = sext i32 %.1 to i64
  %20 = getelementptr inbounds i32, ptr %2, i64 %19
  %21 = load i32, ptr %20, align 4
  %22 = add nsw i32 %18, %21
  %23 = sext i32 %.1 to i64
  %24 = getelementptr inbounds i32, ptr %1, i64 %23
  store i32 %22, ptr %24, align 4
  br label %25

25:                                               ; preds = %15
  %26 = add nsw i32 %.1, 1
  br label %13, !llvm.loop !6

27:                                               ; preds = %13
  br label %28

28:                                               ; preds = %27
  %29 = add nsw i32 %.1, 1
  br label %4, !llvm.loop !8

30:                                               ; preds = %4
  br label %31

31:                                               ; preds = %43, %30
  %.2 = phi i32 [ 0, %30 ], [ %44, %43 ]
  %32 = icmp slt i32 %.2, 100
  br i1 %32, label %33, label %45

33:                                               ; preds = %31
  %34 = sext i32 %.2 to i64
  %35 = getelementptr inbounds i32, ptr %1, i64 %34
  %36 = load i32, ptr %35, align 4
  %37 = sext i32 %.2 to i64
  %38 = getelementptr inbounds i32, ptr %0, i64 %37
  %39 = load i32, ptr %38, align 4
  %40 = add nsw i32 %36, %39
  %41 = sext i32 %.2 to i64
  %42 = getelementptr inbounds i32, ptr %2, i64 %41
  store i32 %40, ptr %42, align 4
  br label %43

43:                                               ; preds = %33
  %44 = add nsw i32 %.2, 1
  br label %31, !llvm.loop !9

45:                                               ; preds = %31
  ret void
}

attributes #0 = { noinline nounwind sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

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
