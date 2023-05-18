; ModuleID = 'Loops.opt.bc'
source_filename = "Loops.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.timespec = type { i64, i64 }

@.str = private unnamed_addr constant [20 x i8] c"Time elapsed: %Lf\0A\0A\00", align 1

; Function Attrs: noinline nounwind sspstrong uwtable
define dso_local void @populate(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  br label %4

4:                                                ; preds = %13, %3
  %.0 = phi i32 [ 0, %3 ], [ %14, %13 ]
  %5 = icmp slt i32 %.0, 9000
  br i1 %5, label %6, label %15

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
  %14 = add nsw i32 %.0, 1
  br label %4, !llvm.loop !6

15:                                               ; preds = %4
  br label %16

16:                                               ; preds = %28, %15
  %.1 = phi i32 [ 0, %15 ], [ %29, %28 ]
  %17 = icmp slt i32 %.1, 9000
  br i1 %17, label %18, label %30

18:                                               ; preds = %16
  %19 = sext i32 %.1 to i64
  %20 = getelementptr inbounds i32, ptr %0, i64 %19
  %21 = load i32, ptr %20, align 4
  %22 = sext i32 %.1 to i64
  %23 = getelementptr inbounds i32, ptr %2, i64 %22
  %24 = load i32, ptr %23, align 4
  %25 = add nsw i32 %21, %24
  %26 = sext i32 %.1 to i64
  %27 = getelementptr inbounds i32, ptr %1, i64 %26
  store i32 %25, ptr %27, align 4
  br label %28

28:                                               ; preds = %18
  %29 = add nsw i32 %.1, 1
  br label %16, !llvm.loop !8

30:                                               ; preds = %16
  ret void
}

; Function Attrs: noinline nounwind sspstrong uwtable
define dso_local i32 @main() #0 {
  %1 = alloca [9000 x i32], align 16
  %2 = alloca [9000 x i32], align 16
  %3 = alloca [9000 x i32], align 16
  %4 = alloca %struct.timespec, align 8
  %5 = alloca %struct.timespec, align 8
  br label %6

6:                                                ; preds = %11, %0
  %.01 = phi i32 [ 0, %0 ], [ %12, %11 ]
  %7 = icmp slt i32 %.01, 9000
  br i1 %7, label %8, label %13

8:                                                ; preds = %6
  %9 = sext i32 %.01 to i64
  %10 = getelementptr inbounds [9000 x i32], ptr %3, i64 0, i64 %9
  store i32 1, ptr %10, align 4
  br label %11

11:                                               ; preds = %8
  %12 = add nsw i32 %.01, 1
  br label %6, !llvm.loop !9

13:                                               ; preds = %6
  %14 = call i32 @clock_gettime(i32 noundef 0, ptr noundef %4) #3
  br label %15

15:                                               ; preds = %21, %13
  %.0 = phi i32 [ 0, %13 ], [ %22, %21 ]
  %16 = icmp slt i32 %.0, 9000
  br i1 %16, label %17, label %23

17:                                               ; preds = %15
  %18 = getelementptr inbounds [9000 x i32], ptr %1, i64 0, i64 0
  %19 = getelementptr inbounds [9000 x i32], ptr %2, i64 0, i64 0
  %20 = getelementptr inbounds [9000 x i32], ptr %3, i64 0, i64 0
  call void @populate(ptr noundef %18, ptr noundef %19, ptr noundef %20)
  br label %21

21:                                               ; preds = %17
  %22 = add nsw i32 %.0, 1
  br label %15, !llvm.loop !10

23:                                               ; preds = %15
  %24 = call i32 @clock_gettime(i32 noundef 0, ptr noundef %5) #3
  %25 = getelementptr inbounds %struct.timespec, ptr %5, i32 0, i32 0
  %26 = load i64, ptr %25, align 8
  %27 = getelementptr inbounds %struct.timespec, ptr %4, i32 0, i32 0
  %28 = load i64, ptr %27, align 8
  %29 = sub nsw i64 %26, %28
  %30 = sitofp i64 %29 to x86_fp80
  %31 = getelementptr inbounds %struct.timespec, ptr %5, i32 0, i32 1
  %32 = load i64, ptr %31, align 8
  %33 = getelementptr inbounds %struct.timespec, ptr %4, i32 0, i32 1
  %34 = load i64, ptr %33, align 8
  %35 = sub nsw i64 %32, %34
  %36 = sitofp i64 %35 to x86_fp80
  %37 = fdiv x86_fp80 %36, 0xK401CEE6B280000000000
  %38 = fadd x86_fp80 %30, %37
  %39 = call i32 (ptr, ...) @printf(ptr noundef @.str, x86_fp80 noundef %38)
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @clock_gettime(i32 noundef, ptr noundef) #1

declare i32 @printf(ptr noundef, ...) #2

attributes #0 = { noinline nounwind sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

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
