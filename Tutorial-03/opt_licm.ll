; ModuleID = 'test/Loop.ll'
source_filename = "test/Loop.ll"

@.str = private constant [25 x i8] c"%d,%d,%d,%d,%d,%d,%d,%d\0A\00", align 1

define void @foo(i32 %0, i32 %1) {
  %3 = add nsw i32 %0, 4
  %4 = add nsw i32 %0, 7
  %5 = add nsw i32 %0, 3
  br label %6

6:                                                ; preds = %15, %2
  %.05 = phi i32 [ 0, %2 ], [ %19, %15 ]
  %.04 = phi i32 [ 0, %2 ], [ %17, %15 ]
  %.03 = phi i32 [ 0, %2 ], [ %16, %15 ]
  %.01 = phi i32 [ 9, %2 ], [ %.1, %15 ]
  %.0 = phi i32 [ %1, %2 ], [ %7, %15 ]
  %7 = add nsw i32 %.0, 1
  %8 = icmp slt i32 %7, 5
  br i1 %8, label %9, label %12

9:                                                ; preds = %6
  %10 = add nsw i32 %.01, 2
  %11 = add nsw i32 %0, 3
  br label %15

12:                                               ; preds = %6
  %13 = sub nsw i32 %.01, 1
  %14 = icmp sge i32 %7, 10
  br i1 %14, label %20, label %15

15:                                               ; preds = %12, %9
  %.02 = phi i32 [ %11, %9 ], [ %3, %12 ]
  %.1 = phi i32 [ %10, %9 ], [ %13, %12 ]
  %16 = add nsw i32 %5, 7
  %17 = add nsw i32 %.02, 2
  %18 = add nsw i32 %0, 7
  %19 = add nsw i32 %4, 5
  br label %6

20:                                               ; preds = %12
  %21 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i64 0, i64 0), i32 %13, i32 %3, i32 %.03, i32 %.04, i32 %4, i32 %.05, i32 %5, i32 %7)
  ret void
}

declare i32 @printf(i8*, ...)

define i32 @main() {
  call void @foo(i32 0, i32 4)
  call void @foo(i32 0, i32 12)
  ret i32 0
}
