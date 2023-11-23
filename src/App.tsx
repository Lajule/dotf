import {useState, useEffect} from 'react';
import './App.css';
import {Code} from './Code';
import {Form} from './Form';
import {Tree} from './Tree';
import Mustache from 'mustache'

const sampleCode = '{"foo": "{{bar}}"}';

function App() {
  const [dotfiles, setDotfiles] = useState(null);
  const [variables, setVariables] = useState(null);

  const fetchDotfiles = async () => {
    const response = await fetch('config.json');
    const config = await response.json()

    setDotfiles(config.dotfiles);
    setVariables(config.variables);
  }

  useEffect(() => {
    fetchDotfiles();
  }, []);

  return (
    <div className="app">
      <div className="sidebar">
        {dotfiles !== null && <Tree dotfiles={dotfiles} />}
      </div>
      <div className="body">
        <div className="variables">
          {variables !== null && <Form variables={variables} />}
        </div>
        <div className="file">
          <div className="template">
            <textarea>It was a dark and stormy night...</textarea>
          </div>
          <div className="preview">
            <Code content={Mustache.render(sampleCode, {bar: "foo bar"})} />
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
