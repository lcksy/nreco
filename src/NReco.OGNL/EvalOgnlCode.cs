#region License
/*
 * NReco library (http://code.google.com/p/nreco/)
 * Copyright 2008 Vitaliy Fedorchenko
 * Distributed under the LGPL licence
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#endregion

using System;
using System.Collections.Generic;
using System.Text;

namespace NReco.OGNL {

	public class EvalOgnlCode : OgnlEval, 
		IProvider<IDictionary<string, object>,object>,
		IProvider<IDictionary<string, object>,bool> {
		string _Code;

		public string Code {
			get { return _Code; }
			set { _Code = value; }
		}

		public object Provide(IDictionary<string, object> context) {
			return Eval(Code, context);
		}

		bool IProvider<IDictionary<string, object>, bool>.Provide(IDictionary<string, object> context) {
			object evalRes = Eval(Code,context);
			if (evalRes is bool)
				return (bool)evalRes;
			return evalRes!=null;
		}

	}
}
