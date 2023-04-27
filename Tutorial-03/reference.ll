; ModuleID = 'test/Loop.ll'
source_filename = "test/Loop.ll"

@.str = private constant [25 x i8] c"%d,%d,%d,%d,%d,%d,%d,%d\0A\00", align 1

define void @foo(i32 %0, i32 %1) {
  %3 = add nsw i32 %0, 3
  %4 = add nsw i32 %0, 7
  %5 = add nsw i32 %0, 4
  %6 = add nsw i32 %0, 3
  %7 = add nsw i32 %3, 7
  %8 = add nsw i32 %4, 5
  br label %9

9:                                                ; preds = %17, %2
  %.05 = phi i32 [ 0, %2 ], [ %8, %17 ]
  %.04 = phi i32 [ 0, %2 ], [ %18, %17 ]
  %.03 = phi i32 [ 0, %2 ], [ %7, %17 ]
  %.01 = phi i32 [ 9, %2 ], [ %.1, %17 ]
  %.0 = phi i32 [ %1, %2 ], [ %10, %17 ]
  %10 = add nsw i32 %.0, 1
  %11 = icmp slt i32 %10, 5
  br i1 %11, label %12, label %14

12:                                               ; preds = %9
  %13 = add nsw i32 %.01, 2
  br label %17

14:                                               ; preds = %9
  %15 = sub nsw i32 %.01, 1
  %16 = icmp sge i32 %10, 10
  br i1 %16, label %19, label %17

17:                                               ; preds = %14, %12
  %.02 = phi i32 [ %6, %12 ], [ %5, %14 ]
  %.1 = phi i32 [ %13, %12 ], [ %15, %14 ]
  %18 = add nsw i32 %.02, 2
  br label %9

19:                                               ; preds = %14
  %.lcssa4 = phi i32 [ %15, %14 ]
  %.lcssa3 = phi i32 [ %5, %14 ]
  %.05.lcssa = phi i32 [ %.05, %14 ]
  %.04.lcssa = phi i32 [ %.04, %14 ]
  %.03.lcssa = phi i32 [ %.03, %14 ]
  %.lcssa2 = phi i32 [ %10, %14 ]
  %.lcssa1 = phi i32 [ %3, %14 ]
  %.lcssa = phi i32 [ %4, %14 ]
  %20 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i64 0, i64 0), i32 %.lcssa4, i32 %.lcssa3, i32 %.03.lcssa, i32 %.04.lcssa, i32 %.lcssa, i32 %.05.lcssa, i32 %.lcssa1, i32 %.lcssa2)
  ret void
}

declare i32 @printf(i8*, ...)

define i32 @main() {
  call void @foo(i32 0, i32 4)
  call void @foo(i32 0, i32 12)
  ret i32 0
}
