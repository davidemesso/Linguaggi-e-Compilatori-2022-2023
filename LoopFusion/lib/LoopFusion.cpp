#include <llvm/Analysis/LoopPass.h>
#include <llvm/Analysis/ValueTracking.h>
#include <llvm/IR/IRBuilder.h>

using namespace llvm;

namespace {

class LoopFusionPass final : public FunctionPass {
public:
  static char ID;

  LoopFusionPass() : FunctionPass(ID) {}

  virtual void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<DominatorTreeWrapperPass>();
    AU.addRequired<LoopInfoWrapperPass>();
  }

  virtual bool runOnFunction(Function &F) override {
    // esempio di strutture dati utili per un passo
    DominatorTree* DT = &getAnalysis<DominatorTreeWrapperPass>().getDomTree();
    LoopInfo* LI = &getAnalysis<LoopInfoWrapperPass>().getLoopInfo();

    outs() << "LOOPFUSION INIZIATO...\n";

    SmallVector<Loop*> loops;

    for(auto &loop: LI->getLoopsInPreorder())
    {
       if(loop->isLoopSimplifyForm()) {
        loop->print(outs(), false);
        outs() << "is in simplified form\n";
        loops.push_back(loop);
      }
    }
    outs() << "\n";

    for(auto &i: loops) {
      for(auto &l: loops) {
        if(i == l)
          continue;
        
        auto preheader = l->getLoopPreheader();
        auto exitBlock = i->getExitBlock();

        if(!exitBlock)
          continue;

        if(exitBlock == preheader)
        {
          l->print(outs(), false);
          outs() << " is adjacent to: ";
          i->print(outs(), false);
        }
      }
    }
    return true;
  }
};

char LoopFusionPass::ID = 0;
RegisterPass<LoopFusionPass> X("fusion",
                             "Loop Fusion");

} // anonymous namespace

