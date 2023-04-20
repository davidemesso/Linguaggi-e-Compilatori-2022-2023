#include <llvm/Analysis/LoopPass.h>
#include <llvm/Analysis/ValueTracking.h>

using namespace llvm;

namespace {

class LoopWalkPass final : public LoopPass {
public:
  static char ID;

  LoopWalkPass() : LoopPass(ID) {}

  virtual void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<DominatorTreeWrapperPass>();
    AU.addRequired<LoopInfoWrapperPass>();
  }

  virtual bool runOnLoop(Loop *L, LPPassManager &LPM) override {
    // esempio di strutture dati utili per un passo
    DominatorTree* DT = &getAnalysis<DominatorTreeWrapperPass>().getDomTree();
    LoopInfo* LI = &getAnalysis<LoopInfoWrapperPass>().getLoopInfo();

    outs() << "LOOPPASS INIZIATO...\n";
  
    // find loop-invariant instructions
    for(auto& bb: L->getBlocks())
    {
      for(auto& i: *bb)
      {
        if(checkInvariance(L, &i))
        {
          outs() << i << " è loop-invariant\n";
          loopInvariantInsts.push_front(&i);
        }
      }
    }

    SmallVector<BasicBlock*> exitBlocks;
    L->getExitBlocks(exitBlocks);

    outs() << "\n";

    std::list<Instruction*> toBeRemoved;

    for(auto& i : loopInvariantInsts)
    {
      BasicBlock* instBB = i->getParent();
      bool res = true;
      for(auto &exitBB : exitBlocks)
      {
        if(res)
          res = DT->dominates(instBB, exitBB);
        else
          break;
      }

      if(res)
      {
        instBB->printAsOperand(outs(), false);
        outs() << " domina tutte le uscite del loop\n";
      }
      else
        toBeRemoved.push_front(i);
    }
    
    for(auto& i: toBeRemoved)
      loopInvariantInsts.remove(i);
    
    outs() << "\n";

    for(auto& i : loopInvariantInsts)
    {
      i->printAsOperand(outs(), false);
      outs() << "\n";
  
      BasicBlock* instBB = i->getParent();
      bool res = true;
      for(auto &use : i->uses())
      {
        Instruction* tmp = dyn_cast<Instruction>(use);

        if(res)
        {
          if(tmp)
            res = DT->dominates(instBB, tmp->getParent());
        }
        else
          break;
      }

      if(res)
      {
        i->printAsOperand(outs(), false);
        outs() << " domina tutti gli usi\n";
      }
      else
        toBeRemoved.push_front(i);
    }
    return false; 
  }

  bool checkInvariance(Loop* L, Instruction* I) {
    if(dyn_cast<BinaryOperator>(I))
    {
      Value* op_right = I->getOperand(1);
      Value* op_left = I->getOperand(0);
      return _isLoopInvariant(L, op_right) && _isLoopInvariant(L, op_left);
    }
    return false;
  }

private:
  std::list<Instruction*> loopInvariantInsts;

  bool _isLoopInvariant(Loop* L, Value* V) {
    if(dyn_cast<Constant>(V) != nullptr)
      return true;

    Instruction* inst = dyn_cast<Instruction>(V);
    if(inst)
      if(!(L->contains(inst)))
        return false;
      else
        return checkInvariance(L, inst);


    return true;
  }
};

char LoopWalkPass::ID = 0;
RegisterPass<LoopWalkPass> X("loop-walk",
                             "Loop Walk");

} // anonymous namespace

