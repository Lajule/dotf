import {FC, useState} from 'react';
import {Node} from './types';
import {Tree} from './Tree';

interface TreeNodeProps {
  node: Node
}

export const TreeNode: FC<TreeNodeProps> = ({node}) => {
  const [collapsed, setCollapsed] = useState(false);

  let elem;
  if (collapsed) {
    elem = "-";
  } else {
    elem = "+";
  }

  return (
    <li>
      {node.children !== undefined && <button onClick={() => setCollapsed(prev => !prev)}>{elem}</button>} <span>{node.file}</span>
      {node.children !== undefined && collapsed &&
        <ul>
          <Tree dotfiles={node.children} />
        </ul>
      }
    </li>
  );
}

