import {FC, useState} from 'react';
import {Node} from './types';
import {Tree} from './Tree';

interface TreeNodeProps {
  node: Node
}

export const TreeNode: FC<TreeNodeProps> = ({node}) => {
  const [collapsed, setCollapsed] = useState(false);

  let elem;
  if (node.children !== undefined) {
    elem = <button onClick={() => setCollapsed(prev => !prev)}>{collapsed ? "-" : "+"}</button>
  } else {
    elem = "|";
  }

  return (
    <li>
      <div>{elem} <button>{node.file}</button></div>
      {node.children !== undefined && collapsed &&
        <ul>
          <Tree dotfiles={node.children} />
        </ul>
      }
    </li>
  );
}
