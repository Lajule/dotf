import {useState, useEffect} from 'react';
import './App.css';
import {CodeBlock} from './CodeBlock';
import {Tree} from './Tree';
import Mustache from 'mustache'

const sampleCode = '{"foo": "{{bar}}"}';

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
      <div className="sidebar">
        {dotfiles !== null && <Tree dotfiles={dotfiles} />}
      </div>
      <div className="body">
        <div className="variables">
          <form>
            <div>
              <label htmlFor="foo">foo: </label>
              <input type="text" name="foo" id="foo" required />
            </div>
            <div>
              <label htmlFor="bar">bar: </label>
              <input type="text" name="bar" id="bar" required />
            </div>
          </form>
        </div>
        <div className="file">
          <div className="template">
            <textarea>It was a dark and stormy night...</textarea>
          </div>
          <div className="preview">
            <CodeBlock content={Mustache.render(sampleCode, {bar: "foo bar"})} />
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
