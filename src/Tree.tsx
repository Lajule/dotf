import {FC} from 'react';
import {Node} from './types';
import {TreeNode} from './TreeNode';

interface TreeProps {
  dotfiles: ReadonlyArray<Node>;
}

export const Tree: FC<TreeProps> = ({ dotfiles }) => {
  return (
    <ul>
      {dotfiles.map((node, i) => (
        <TreeNode key={node.file + i} node={node}/>
      ))}
    </ul>
  );
}
