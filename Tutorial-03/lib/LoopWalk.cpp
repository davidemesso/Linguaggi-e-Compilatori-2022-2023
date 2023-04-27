#include <llvm/Analysis/LoopPass.h>
#include <llvm/Analysis/ValueTracking.h>
#include <llvm/IR/IRBuilder.h>

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
          loopInvariantInsts.push_back(&i);
        }
      }
    }

    SmallVector<BasicBlock*> exitBlocks;
    L->getExitBlocks(exitBlocks);

    outs() << "\n";

    std::set<Instruction*> toBeRemoved;

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
      // rilassamento della condizione
      if(!res)
      {
        res = true;
        for(auto& i : loopInvariantInsts)
        {
          for(auto& use: i->uses())
          {
            Instruction* tmp = dyn_cast<Instruction>(use);
            if(tmp && !L->contains(tmp->getParent()))
            {
                res = false;
                break;
            }
          }
        }
      }
      if(res)
      {
        instBB->printAsOperand(outs(), false);
        outs() << " domina tutte le uscite del loop\n";
      }
      else
        toBeRemoved.insert(i);
    }
    
    for(auto& i: toBeRemoved)
      loopInvariantInsts.remove(i);
    
    outs() << "\n";

    for(auto& i : loopInvariantInsts)
    {
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
        toBeRemoved.insert(i);
    }

    BasicBlock* header = L->getHeader();
    BasicBlock* preheader = L->getLoopPreheader();

    if(!preheader)
    {

      preheader = BasicBlock::Create(header->getContext(), "Preheader", header->getParent());
      preheader->moveBefore(header);
    }
    else
      outs() << "\nIl preheader già esiste\n";

    Instruction* insertionPoint = nullptr;

    for(auto& point : *preheader)
    {
        insertionPoint = &point;
        break;
    }
    for(auto& i : loopInvariantInsts)
    {
      i->moveBefore(insertionPoint);
    }
    outs() << "Le istruzioni loop-invariant spostabili sono saltate nel preheader\n";
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

