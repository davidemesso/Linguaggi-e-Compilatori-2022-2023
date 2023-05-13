; ModuleID = 'test/loops/Loops.opt.ll'
source_filename = "Loops.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind sspstrong uwtable
define dso_local void @populate(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  br label %4

4:                                                ; preds = %23, %3
  %.0 = phi i32 [ 0, %3 ], [ %24, %23 ]
  %5 = icmp slt i32 %.0, 100
  br i1 %5, label %6, label %25

6:                                                ; preds = %4
  %7 = sext i32 %.0 to i64
  %8 = getelementptr inbounds i32, ptr %2, i64 %7
  %9 = load i32, ptr %8, align 4
  %10 = mul nsw i32 5, %9
  %11 = sext i32 %.0 to i64
  %12 = getelementptr inbounds i32, ptr %0, i64 %11
  store i32 %10, ptr %12, align 4
  br label %23

13:                                               ; No predecessors!
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
  br label %28

23:                                               ; preds = %6
  %24 = add nsw i32 %.0, 1
  br label %4, !llvm.loop !6

25:                                               ; preds = %4
  br label %26

26:                                               ; preds = %28, %25
  %.1 = phi i32 [ 0, %25 ], [ %29, %28 ]
  %27 = icmp slt i32 %.0, 100
  br i1 %27, label %.split, label %30

.split:                                           ; preds = %26
  br label %28

28:                                               ; preds = %.split, %13
  %29 = add nsw i32 %.0, 1
  br label %26, !llvm.loop !8

30:                                               ; preds = %26
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
