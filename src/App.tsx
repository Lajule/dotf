import {useState, useEffect} from 'react';
import './App.css';
import {CodeBlock} from './CodeBlock';
import {Tree} from './Tree';

const sampleCode = '{"foo": "bar"}';

function App() {
  const [dotfiles, setDotfiles] = useState(null);

  const fetchDotfiles = async () => {
    const response = await fetch('config.json');
    const config = await response.json();
    setDotfiles(config.dotfiles);
  }

  useEffect(() => {
    fetchDotfiles();
  }, []);

  return (
    <div className="app">
      <p>Dotf</p>
      <CodeBlock content={sampleCode} />
      {dotfiles !== null && <Tree dotfiles={dotfiles} />}
    </div>
  );
}

export default App;
