// MATH AND VECTOR SUPPORT
let TAU       = 2 * Math.PI;
let map1      = (f,a)   => a.map((a,i) => f(a));
let map2      = (f,a,b) => a.map((a,i) => f(a, b[i]));
let clone3    = (a)     => [a[0], a[1], a[2]];
let xz        = (a)     => [a[0], a[2]];
let add       = (a,b)   => a.map((a,i) => a + b[i]);
let cross     = (a,b)   => [ a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0] ];
let distance  = (a,b)   => norm(subtract(a,b));
let dot       = (a,b)   => a.map((a,i) => a*b[i]).reduce((acc, v) => v+acc, 0);
let ease      = t       => (t = Math.max(0,Math.min(1,t))) * t * (3 - t - t);
let mix       = (a,b,t) => a[0]!==undefined ? a.map((a,i) => a + t * (b[i] - a)) : a + t * (b - a);
let norm      = v       => Math.sqrt(dot(v,v));
let normalize = v       => scale(v, 1 / norm(v));
let scale     = (a,s)   => a.map((a,i) => (s[i]!==undefined ? s[i] : s) * a);
let subtract  = (a,b)   => a.map((a,i) => a - b[i]);


// PHYSICS

function Spring() {
   this.getPosition = () => P;
   this.setDamping  = d  => D = d;
   this.setForce    = f  => F = f;
   this.setMass     = m  => M = Math.max(0.001, m);
   this.update = e => {
      V += (F - P) / M * e;
      P  = (P + V) * (1 - D * e);
   }
   let D = 1, F = 0, M = 1, P = 0, V = 0;
}

// MATRIX SUPPORT

let mInverse = m => {
   let d = [], de = 0, co = (c, r) => {
      let s = (i, j) => m[c+i & 3 | (r+j & 3) << 2];
      return (c+r & 1 ? -1 : 1) * ( (s(1,1) * (s(2,2) * s(3,3) - s(3,2) * s(2,3)))
                                  - (s(2,1) * (s(1,2) * s(3,3) - s(3,2) * s(1,3)))
                                  + (s(3,1) * (s(1,2) * s(2,3) - s(2,2) * s(1,3))) );
   }
   for (let n = 0 ; n < 16 ; n++) d.push(co(n >> 2, n & 3));
   for (let n = 0 ; n <  4 ; n++) de += m[n] * d[n << 2]; 
   for (let n = 0 ; n < 16 ; n++) d[n] /= de;
   return d;
}
let mxm = (a, b) => {
   let d = [];
   for (let n = 0 ; n < 16 ; n++)
      d.push(a[n&3]*b[n&12] + a[n&3|4]*b[n&12|1] + a[n&3|8]*b[n&12|2] + a[n&3|12]*b[n&12|3]);
   return d;
}
let C = t => Math.cos(t), S = t => Math.sin(t);
let mId = () => [ 1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1 ];
let mPe =(fl, m) => mxm(m, [1,0,0,0, 0,1,0,0, 0,0,1,-1/fl, 0,0,0,1]);
let mRX = (t, m) => mxm(m, [1,0,0,0, 0,C(t),S(t),0, 0,-S(t),C(t),0, 0,0,0,1]);
let mRY = (t, m) => mxm(m, [C(t),0,-S(t),0, 0,1,0,0, S(t),0,C(t),0, 0,0,0,1]);
let mRZ = (t, m) => mxm(m, [C(t),S(t),0,0, -S(t),C(t),0,0, 0,0,1,0, 0,0,0,1]);
let mSc = (x,y,z, m) => mxm(m, [x,0,0,0, 0,y,0,0, 0,0,z,0, 0,0,0,1]);
let mTr = (x,y,z, m) => mxm(m, [1,0,0,0, 0,1,0,0, 0,0,1,0, x[0]!==undefined?x[0]:x,
                                                           x[0]!==undefined?x[1]:y,
                                                           x[0]!==undefined?x[2]:z,1]);

function Matrix() {
   let stack = [mId()], top = 0;
   let set = arg => { stack[top] = arg; return this; }
   let get = () => stack[top];
   this.aim = (W,i) => {
      W = normalize(W);
      let a = cross(W,[1,0,0]), b = cross(W,[0,1,0]);
      let U = normalize(dot(a,a) > dot(b,b) ? a : b), V = cross(W,U);
      let A = i==0 ? [W,U,V] : i==1 ? [V,W,U] : [U,V,W];
      set(mxm(get(), [ A[0],0, A[1],0, A[2],0, 0,0,0,1 ].flat()));
      return this;
   }
   this.identity = () => set(mId());
   this.perspective = fl => set(mPe(fl, get()));
   this.turnX = t => set(mRX(t, get()));
   this.turnY = t => set(mRY(t, get()));
   this.turnZ = t => set(mRZ(t, get()));
   this.scale = (x,y,z) => set(mSc(x,y?y:x,z?z:x, get()));
   this.move = (x,y,z) => set(mTr(x,y,z, get()));
   this.get = () => get();
   this.S = () => set(stack[top++].slice());
   this.R = () => --top;
   this.draw = (shape,color,opacity,texture,bumpTexture) => draw(shape,color,opacity,texture,bumpTexture);
}

// INITIALIZE WEBGL

let start_gl = (canvas, vertexShader, fragmentShader) => {
   let gl = canvas.getContext("webgl");
   let program = gl.createProgram();
   gl.program = program;
   let addshader = (type, src) => {
      let shader = gl.createShader(type);
      gl.shaderSource(shader, src);
      gl.compileShader(shader);
      if (! gl.getShaderParameter(shader, gl.COMPILE_STATUS))
         throw "Cannot compile shader:\n\n" + gl.getShaderInfoLog(shader);
      gl.attachShader(program, shader);
   };

   for (let i in materials) {
      let index = fragmentShader.indexOf('// MATERIAL');
      fragmentShader = fragmentShader.substring(0, index)
                     + 'if (uMaterial == ' + i + ') {' + materials[i] + '}'
                     + fragmentShader.substring(index);
   }

   addshader(gl.VERTEX_SHADER  , vertexShader  );
   addshader(gl.FRAGMENT_SHADER, fragmentShader);
   gl.linkProgram(program);
   if (! gl.getProgramParameter(program, gl.LINK_STATUS))
      throw "Could not link the shader program!";
   gl.useProgram(program);
   gl.bindBuffer(gl.ARRAY_BUFFER, gl.createBuffer());
   gl.enable(gl.DEPTH_TEST);
   gl.enable(gl.BLEND);
   gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
   gl.depthFunc(gl.LEQUAL);
   let vertexAttribute = (name, size, position) => {
      let attr = gl.getAttribLocation(program, name);
      gl.enableVertexAttribArray(attr);
      gl.vertexAttribPointer(attr, size, gl.FLOAT, false, vertexSize * 4, position * 4);
   }
   vertexAttribute('aPos', 3, 0);
   vertexAttribute('aNor', 3, 3);
   vertexAttribute('aUV' , 2, 6);
   vertexAttribute('aTan', 3, 8);
   return gl;
}

// IMPLEMENT VARIOUS 3D SHAPES

let createMesh = (nu, nv, p) => {
   let V = (u,v) => {
      let P = p(u,v);
      let getD = (du,dv) => {
         let Q = p(u+du,v+dv);
         let x = Q[0]-P[0], y = Q[1]-P[1], z = Q[2]-P[2], s = Math.sqrt(x*x + y*y + z*z);
         return [ x/s, y/s, z/s ];
      }
      let U = getD(.001, 0);
      if (P.length < 6)
         P = P.concat(cross(U, getD(0, .001)));
      return P.concat([u, 1-v, U[0], U[1], U[2]]);
   }

   let mesh = [];
   for (let j = nv-1 ; j >= 0 ; j--) {
      for (let i = 0 ; i <= nu ; i++)
         mesh.push(V(i/nu,(j+1)/nv),  V(i/nu,j/nv));
      mesh.push(V(1,j/nv), V(0,j/nv));
   }
   return new Float32Array(mesh.flat());
}
let sphere = (nu, nv) => createMesh(nu, nv, (u,v) => {
   let theta = 2 * Math.PI * u;
   let phi = Math.PI * (v - .5);
   let x = C(phi) * C(theta),
       y = C(phi) * S(theta),
       z = S(phi);
   return [ x,y,z ];
});
let tube = (nu, nv, i) => createMesh(nu, nv, (u,v) => {
   let U = C(2 * Math.PI * u),
       V = S(2 * Math.PI * u),
       W = 2 * v - 1;
   return i==0 ? [W,U,V] : i==1 ? [V,W,U] : [U,V,W];
});
let disk = (nu, nv) => createMesh(nu, nv, (u,v) => {
   let x = v * C(2 * Math.PI * u),
       y = v * S(2 * Math.PI * u);
   return [ x,y,0, 0,0,1 ];
});
let cylinder = (nu, i, r) => createMesh(nu, 6, (u,v) => {
   r = r ? r : 1;
   let x = C(2 * Math.PI * u),
       y = S(2 * Math.PI * u),
       t = Math.sqrt(4 + (1-r)*(1-r)), a = 2/t, b = (1-r)/t;
       swizzle = v => i==0 ? [v[2],v[0],v[1], v[5],v[3],v[4]]
                    : i==1 ? [v[1],v[2],v[0], v[4],v[5],v[3]]
                           : [v[0],v[1],v[2], v[3],v[4],v[5]];
   switch (5 * v >> 0) {
   case 0: return swizzle([   0,  0,-1,    0,  0,-1 ]);
   case 1: return swizzle([   x,  y,-1,    0,  0,-1 ]);
   case 2: return swizzle([   x,  y,-1,  a*x,a*y, b ]);
   case 3: return swizzle([ r*x,r*y, 1,  a*x,a*y, b ]);
   case 4: return swizzle([ r*x,r*y, 1,    0,  0, 1 ]);
   case 5: return swizzle([   0,  0, 1,    0,  0, 1 ]);
   }
});
let torus = (nu, nv, r, t) => createMesh(nu, nv, (u,v) => {
   r = r ? r : .5;
   t = t ? t : 1;
   let ct = C(2 * Math.PI * u);
   let st = S(2 * Math.PI * u);
   let cp = C(2 * Math.PI * v);
   let sp = S(2 * Math.PI * v);
   let x = (1 + r * cp) * ct,
       y = (1 + r * cp) * st,
       z =      r * Math.max(-t, Math.min(t, sp));
   return [ x,y,z ];
});
let strToTris = s => {
   let t = [], i;
   for (let n = 0 ; n < s.length ; n++)
      if ((i = 'N01'.indexOf(s.charAt(n))) >= 0)
         t.push(i-1);
   return new Float32Array(t);
}
let square=strToTris(`1N000111100 11000110100 N1000100100  N1000100100 NN000101100 1N000111100`);
let cube = strToTris(`1N100111100 11100110100 N1100100100  N1100100100 NN100101100 1N100111100
                      N1N00N01N00 11N00N11N00 1NN00N10N00  1NN00N10N00 NNN00N00N00 N1N00N01N00
                      11N10011010 11110010010 1N110000010  1N110000010 1NN10001010 11N10011010
                      NN1N00100N0 N11N00000N0 N1NN00010N0  N1NN00010N0 NNNN00110N0 NN1N00100N0
                      N1101011001 11101010001 11N01000001  11N01000001 N1N01001001 N1101011001
                      1NN0N00100N 1N10N01100N NN10N01000N  NN10N01000N NNN0N00000N 1NN0N00100N`);

// API FOR ACCESSING 3D SHAPES

let Cube     = ()      => { return { type: 0, mesh: cube }; }
let Cylinder = (n,i,r) => { return { type: 1, mesh: cylinder(n, i, r) }; }
let Disk     = n       => { return { type: 1, mesh: disk    (n, 1) }; }
let Sphere   = n       => { return { type: 1, mesh: sphere  (n, n>>1) }; }
let Square   = ()      => { return { type: 0, mesh: square }; }
let Torus    = (n,r,t) => { return { type: 1, mesh: torus   (n, n, r, t) }; }
let Tube     = (n,i)   => { return { type: 1, mesh: tube    (n, 1, i) }; }

let CreateMesh = (nu,nv,f) => { return { type: 1, mesh: createMesh(nu,nv,f) }; }

let superquadric = (t,p) => {
   let f = (4 * t >> 0) / 4;
   t -= f + .125;
   t = TAU * (Math.sign(t) * Math.pow(Math.abs(8*t),1/p)/8 + f);
   let x = C(t), ax = Math.abs(x);
   let y = S(t), ay = Math.abs(y);
   let r = Math.pow(Math.pow(ax,p) + Math.pow(ay,p), 1/p);
   return [Math.sign(x)*ax/r, Math.sign(y)*ay/r];
}

// GPU SHADERS

let vertexSize = 11;
let vertexShader = `
   attribute vec3 aPos, aNor, aTan;
   attribute vec2 aUV;
   uniform mat4 uMatrix, uInvMatrix, uVMatrix, uVInvMatrix;
   varying vec3 vPos, vNor, vTan, vTpos;
   varying vec2 vUV;

   uniform float uEye;
   varying float vClipX;

   void main() {
      vec4 pos = uVMatrix * uMatrix * vec4(aPos, 1.0);
      vec4 nor = vec4(aNor, 0.0) * uInvMatrix * uVInvMatrix;
      vec4 tan = vec4(aTan, 0.0) * uInvMatrix * uVInvMatrix;
      vec4 tpos = uMatrix * vec4(aPos, 1.0);
      vPos = pos.xyz;
      vNor = nor.xyz;
      vTan = tan.xyz;
      vTpos = tpos.xyz;
      vUV  = aUV;

      pos = mix(pos, vec4(.5 * pos.xyz, pos.w), uEye * uEye);
      pos.x += .45 * pos.w * uEye;
      vClipX = pos.x * uEye;

      gl_Position = pos * vec4(1.,1.,-.1,1.);
   }
`;
let fragmentShader = `
   precision mediump float;
   float noise(vec3 point) { float r = 0.; for (int i=0;i<16;i++) {
     vec3 D, p = point + mod(vec3(i,i/4,i/8), vec3(4.0,2.0,2.0)) + 1.7*sin(vec3(i,5*i,8*i));
	 vec3 C=floor(p);
	 vec3 P=p-C-.5;
	 vec3 A=abs(P);
     C += mod(C.x+C.y+C.z,2.) * step(max(A.yzx,A.zxy),A) * sign(P);
     D=34.*sin(987.*float(i)+876.*C+76.*C.yzx+765.*C.zxy);
	 P=p-C-.5;
     r+=sin(6.3*dot(P,fract(D)-.5))*pow(max(0.,1.-2.*dot(P,P)),4.);
   } return .5 * sin(r); }
   uniform sampler2D uSampler[16];
   uniform vec3 uColor;
   uniform float uOpacity;
   uniform int uTexture, uBumpTexture, uMaterial;
   varying vec3 vPos, vNor, vTan, vTpos;
   varying vec2 vUV;

   varying float vClipX;

   void main(void) {

      if (vClipX < 0.)
         discard;

      vec4 texture = vec4(1.);
      vec3 nor = normalize(vNor);
      for (int i = 0 ; i < 16 ; i++) {
         if (uTexture == i)
            texture = texture2D(uSampler[i], vUV);
         if (uBumpTexture == i) {
            vec3 b = 2. * texture2D(uSampler[i], vUV).rgb - 1.;
            vec3 tan = normalize(vTan);
            vec3 bin = cross(nor, tan);
            nor = normalize(b.x * tan + b.y * bin + b.z * nor);
         }
      }
      vec3 L = vec3(.577), E = vec3(0.,0.,1.);
      float c = .05 + max(0., dot(L, nor)) + max(0., dot(-L, nor));;
      vec3 color = sqrt(uColor * c) * texture.rgb;
      float power = 40.;
      // MATERIAL
      color += pow(max(0., dot(normalize(E+L), nor)), power)
             + pow(max(0., dot(normalize(E-L), nor)), power);
      gl_FragColor = vec4(color, uOpacity * texture.a);
   }
`;

let materials = [];
let addMaterial = (i,s) => materials[i] = s;

// DECLARE GL-RELATED VARIABLES AND MATRIX OBJECT

let gl, uBumpTexture, uColor, uEye, uInvMatrix, uMaterial, uMatrix, uOpacity, uSampler, uTexture, uVnvMatrix, uVMatrix;

let startGL = canvas => {
   gl = start_gl(canvas, vertexShader, fragmentShader);
   uBumpTexture = gl.getUniformLocation(gl.program, "uBumpTexture");
   uColor       = gl.getUniformLocation(gl.program, "uColor"      );

   uEye         = gl.getUniformLocation(gl.program, "uEye"        );

   uInvMatrix   = gl.getUniformLocation(gl.program, "uInvMatrix"  );
   uMaterial    = gl.getUniformLocation(gl.program, "uMaterial"   );
   uMatrix      = gl.getUniformLocation(gl.program, "uMatrix"     );
   uOpacity     = gl.getUniformLocation(gl.program, "uOpacity"    );
   uSampler     = gl.getUniformLocation(gl.program, "uSampler"    );
   uTexture     = gl.getUniformLocation(gl.program, "uTexture"    );
   uVInvMatrix  = gl.getUniformLocation(gl.program, "uVInvMatrix" );
   uVMatrix     = gl.getUniformLocation(gl.program, "uVMatrix"    );
   gl.uniform1iv(uSampler, [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]);
}

let M = new Matrix();
let VM = new Matrix();
VM.identity();

// LOAD A TEXTURE IMAGE

let animatedSource = [];
let material = 0;

let texture = (index, source) => {
   if (typeof source == 'string') {

      // IF THE TEXTURE SOURCE IS AN IMAGE FILE, IT ONLY NEEDS TO BE SENT TO THE GPU ONCE.

      let image = new Image();
      image.onload = () => {
         gl.activeTexture (gl.TEXTURE0 + index);
         gl.bindTexture   (gl.TEXTURE_2D, gl.createTexture());
         gl.texImage2D    (gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image);
         gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR_MIPMAP_NEAREST);
         gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_NEAREST);
         gl.generateMipmap(gl.TEXTURE_2D);
      }
      image.src = source;
   }
   else {

      // IF THE TEXTURE SOURCE IS ANYTHING ELSE, ITS CONTENT CAN CHANGE AT EVERY ANIMATION FRAME.

      gl.activeTexture (gl.TEXTURE0 + index);
      gl.bindTexture   (gl.TEXTURE_2D, gl.createTexture());
      gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
      gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
      animatedSource[index] = source;
   }
}

// DRAW A SINGLE SHAPE TO THE WEBGL CANVAS

let draw = (Shape, color, opacity, texture, bumpTexture) => {

   // IF THIS IS AN ANIMATED TEXTURE SOURCE, SEND THE TEXTURE TO THE GPU AT EVERY ANIMATION FRAME.

   if (animatedSource[texture]) {
      gl.activeTexture(gl.TEXTURE0 + texture);
      gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, animatedSource[texture]);
   }

   gl.uniform1f       (uOpacity    , opacity===undefined ? 1 : opacity);
   gl.uniform1i       (uTexture    , texture===undefined ? -1 : texture);
   gl.uniform1i       (uBumpTexture, bumpTexture===undefined ? -1 : bumpTexture);
   gl.uniform1i       (uMaterial   , material);
   gl.uniform3fv      (uColor      , color );
   gl.uniformMatrix4fv(uVInvMatrix , false, mInverse(VM.get()));
   gl.uniformMatrix4fv(uVMatrix    , false, VM.get()          );
   gl.uniformMatrix4fv(uInvMatrix  , false, mInverse(M.get()));
   gl.uniformMatrix4fv(uMatrix     , false, M.get()          );
   gl.bufferData(gl.ARRAY_BUFFER, Shape.mesh, gl.STATIC_DRAW);
   gl.drawArrays(Shape.type ? gl.TRIANGLE_STRIP : gl.TRIANGLES, 0, Shape.mesh.length / vertexSize);
   return M;
}

// DRAW THE SCENE

let drawScene = drawFunction => { drawFunction(); }

// FABRIK INVERSE KINEMATICS

function FABRIK() {
	this.getPoints  = () => P;
	this.getBase    = () => B;
	this.getTarget  = () => T;
	this.getTargetN  = () => TargetN;
	this.getLengths = () => L;
	this.getN       = () => N;
	this.getActJ    = () => ActJ;
	this.getActS    = () => ActS;
	this.getDir     = () => D;
	this.getAge     = () => Age;
	this.getPoint   = (i) => P[i];
	this.getLength  = (i) => L[i];

	this.setBase   = (base)   => { 
		B = base;
	}
	this.setTarget = (target) => T = target;
	this.setPoints = (points) => {
		P = points;
		N = points.length;
		L = [];
		for (let i = 0; i < N - 1; i++) {
			L[i] = distance(P[i], P[i+1]);
		} 
	}
	this.reset = () => {
		ActS = N - 2;
		ActJ = N - 1;
		D = -1;
		TargetN = T;
		Age = 0;
		// Offset all points so the first one lies on base
		let BD = subtract(B, P[0]);
		for (let i = 0; i < N; i++) {
			P[i] = add(P[i], BD);
		}
	}
	this.step = () => {
	 	P[ActJ] = TargetN;
		let Diff = subtract(P[ActJ + D], P[ActJ]);
		TargetN = add(TargetN, scale(Diff, L[ActS] / norm(Diff)));
		ActJ += D;
		if (ActJ == 0) {
			P[ActJ] = TargetN;
			TargetN = B;
			D = 1;
		} else if (ActJ == N - 1) {
			P[ActJ] = TargetN;
			TargetN = T;
			D = -1;
		}
		ActS = ActJ + Math.min(D, 0);
		Age += 1;
	}
	this.iterate = (C) => {
	    for (let i = 0; i < 2 * C * (N - 1) ; i ++) {
			this.step();
		} 
	}
	// this.straightenV = () => {
	//     let H = normalize(scale(add(normalize(subtract(T, B)), [0,1,0]), 0.5));
	// 	let LT = L.reduce((a,b)=>a+b);
	// 	P[0] = B;
	// 	for (let i = 1; i < N; i += 1) {
	// 		P[i] = add(P[i-1], scale(H, L[i-1]));
	// 		
	// 	}
	// }
	let P = [], L = [], N = 0, B = [], T = [], ActS = 0, ActJ = 0, D = -1, TargetN = [], Age = 0;
}

let make_FABRIK = (target, points) => {
	let F = new FABRIK();
	F.setBase(points[0]);
	F.setTarget(target);
	F.setPoints(points);
	F.reset();
	return F;
}




// GRID OF POINTS

let G_xz = (N, L, i) => (-L + 2 * L * i / N) 

// Create an (N+1)x(N+1) Float32 array sampled by f 
// at each point (from [-L,L]x[-L,L])
let G_sample = (N, L, f) => {
	let M = [];
	for (let i = 0; i <= N; i++) {
		for (let j = 0; j <= N; j++) {
			M.push(f(G_xz(N, L, i), G_xz(N, L, j)));
		}
	}
	return new Float32Array(M);
}

// Read coordinates
let G_y  = (G, N, i, j) => G[i*(N+1)+j];
let G_xyz = (G, N, L, i, j) => [G_xz(N, L, i), G_y(G, N, i, j), G_xz(N, L, j)];

// Mesh of triangles for grid
let MkGSurf = (G, nn, L) => {
	let M = [];
	for (let i = 0; i < nn; i++) {
		for (let j = 0; j < nn; j++) {
			// Square:
			// b -- d   ^
			// |    |   | +z
			// a -- c   |
			//  ---> +x

			let a = G_xyz(G, nn, L, i  , j  );
			let b = G_xyz(G, nn, L, i  , j+1);
			let c = G_xyz(G, nn, L, i+1, j  );
			let d = G_xyz(G, nn, L, i+1, j+1);

			// FIXME: Not sure if this needs to be flipped do to handedness
			let N = normalize(cross(subtract(c, a), subtract(b, a)));
			let T = normalize(subtract(c, a));
			// pos, nor, tan, uv
			let a_rend = [ a[0], a[1], a[2], N[0], N[1], N[2], T[0], T[1], T[2], i/N, j/N ];
			let b_rend = [ b[0], b[1], b[2], N[0], N[1], N[2], T[0], T[1], T[2], i/N, (j+1)/N ];
			let c_rend = [ c[0], c[1], c[2], N[0], N[1], N[2], T[0], T[1], T[2], (i+1)/N, j/N ];
			let d_rend = [ d[0], d[1], d[2], N[0], N[1], N[2], T[0], T[1], T[2], (i+1)/N, (j+1)/N ];

			M = M.concat(a_rend);
			M = M.concat(c_rend);
			M = M.concat(b_rend);
			M = M.concat(b_rend);
			M = M.concat(d_rend);
			M = M.concat(c_rend);
		}
	}
	return new Float32Array(M);
}


let GSurf = (G, N, L) => { return { type: 0, mesh: MkGSurf(G, N, L) }; }

let Ginterpolate = (G, N, L, x, z) => {
	let extent_len = 2 * L / N;

	let u = Math.floor((x + L) / extent_len);
	let xbias = (x - G_xz(N, L, u)) / extent_len;
	let v = Math.floor((z + L) / extent_len);
	let zbias = (z - G_xz(N, L, v)) / extent_len;

	let av = G_y(G, N, u, v);
	let cv = G_y(G, N, u+1, v);
	let bv = G_y(G, N, u, v+1);

	return (av + mix(0, cv-av, xbias) + mix(0, bv-av, zbias));
}

let Gval = (G, N, L, x, z) => [x, Ginterpolate(G, N, L, x, z), z];


// HELPER FUNCTIONS

let circle_pattern_gen = (r, N, a) => {
    let R = [];
    for (let i = -1; i < N-1; i++) {
        R.push([r * Math.sin(i * TAU / N + a), 0, r * Math.cos(i * TAU / N + a)]);
    }
    return R;
}


let circle_pattern  = (r, N) => cicle_pattern_gen(r, N, 0);

let feet_pattern = (r, N, a) => {
    N += 2;
    let R = circle_pattern_gen(r, N, a);
	let Ret = [];
	for (let i = 0; i < R.length; i++) {
		if (i != 1 && i != (N/2)+1) {
			Ret.push(R[i]);
		}
	}
    return Ret;
}



// TRIG NOISE

let mktrignoise = (depth) => { 
	let M = [];
	//   Amplitude x, z, frequency x z, offset x z
	for (let i = 0; i < depth; i++) {
		M = M.concat ([[Math.pow(.6, i) * Math.random(), 
						0.5 * Math.pow(2.5, i) * Math.random(),
						0.5 * Math.pow(2.5, i) * Math.random(),
						TAU * Math.random(),
						TAU * Math.random()]]);
	}
	return M;
}

let trignoise = (x, z, n) => {
	let r = 0;
	for(let i = 0; i < n.length; i++) {
		r += n[i][0] * Math.sin(n[i][1] * x + n[i][3]);
		r += n[i][0] * Math.sin(n[i][2] * z + n[i][4]);
	}
	return r;
}


// ANGLE HELPERS


// Angle between [0, tau] starting at [1, 0] 
let atanN = (x, z) => (Math.atan2(z, x) + TAU) % TAU;

// ThetaC, ThetaP in [0, 2pi]
// ThetaA in [0, pi]
// Returns 1 iff ThetaP is within [ThetaC-ThetaA, ThetaC+ThetaA]
let inAngle = (ThetaC, ThetaA, ThetaP) => {
	let x = (ThetaP + ThetaA - ThetaC + TAU) % TAU;
  	if ((0 <= x) && (x <= 2 * ThetaA)) { return 1; }
	return 0;
}


// Returns which region is closest
// in: 0
// above: 1
// below: 2
// behind: 3

let legSeg = (ThetaC, ThetaA, ThetaP) => {
	// Wasted computation here. Optimize if needed.
	if (inAngle(ThetaC, ThetaA, ThetaP)) { return 0; }
	else if (inAngle((ThetaC + Math.PI) % TAU , (Math.PI/2 - ThetaA + TAU) % Math.PI, ThetaP)) { return 3; }
	else if (inAngle((ThetaC + Math.PI/2) % TAU , Math.PI/2, ThetaP)) { return 2; }
	else return 1;
	return -1;
}







// SPIDER


function SPIDER() {
	this.spawn = (Nv, Lv, Av, Sv, Hv, Mv, Dv, rBrv, fLv, rTv, tSv, tPv, BAv, spawn_xz, floorv) => {
		// N = Nv; // Number of legs
		N = 8;
		L = Lv; // Length of legs
		A = Av; // Leg max angle
		S = Sv; // Number of segments
		H = Hv; // Height
		rBr = rBrv;  // Radius of body
		fL = fLv;	 // Foot Lift
		tS = tSv; // Step time
		tP = tPv; // Pause time
		rT = rTv; // Turning rate
		sF = 1; // Stride factor
		floor = floorv;

    	let rLrS = Math.sin(TAU/N/2);
    	rLr = rBr * rLrS / (1 + rLrS);
		this.refresh_shoulders();

		rWr =  0.35 * Math.sqrt(Math.pow(L, 2) + Math.pow(H,2)); // Resting width
		BA = BAv;

		SpX = new Spring();
		SpX.setMass(Mv);
		SpX.setDamping(Dv);
		SpY = new Spring();
		SpY.setMass(10*Mv);
		SpY.setDamping(Dv);
		SpZ = new Spring();
		SpZ.setMass(Mv);
		SpZ.setDamping(Dv);

		let InitialPosition = this.calculate_ideal(spawn_xz, BA);
		for (let i = 0; i < N; i++) {
			LPosReal[i] = clone3(InitialPosition[i]);
			LPosRealistic[i] = clone3(InitialPosition[i]);
			LPosIdeal[i] = clone3(InitialPosition[i]);
			LPosLast[i] = clone3(InitialPosition[i]);
			LimbActivity[i] = 0;
		}

		LimbActiveP = 0;
		AngleIdeal = BA;
		LastAngle = BA;

		LastSpringUpdateTime = Date.now() / 1000;
		this.refresh_com();

		for (let i = 0; i < N; i++) {
			let f = new FABRIK();
			Limbs[i] = f;
		}
		this.resetLimbs();
		this.iterateLimbs(20);
	}
	this.getN = () => N;
	this.getL = () => L;
	this.getA = () => A;
	this.getS = () => S;
	this.getH = () => H;
	this.getM = () => M;

	this.getrBr = () => rBr;
	this.getrLr = () => rLr;
	this.getrWr = () => rWr;
	this.getrBA = () => BA;

	this.resetLimbs = () =>  {
		for (let i = 0; i < N; i++) {
			Limbs[i].setBase(this.getShoulder(i));
			Limbs[i].setTarget(LPosReal[i]);
			let P = [];
			P[0] = this.getShoulder(i);
			let Ang = this.getLimbAngle(i);
			let Dir = normalize([Math.cos(Ang),L,-Math.sin(Ang)]);
			for (let j = 0; j < S; j++) {
				P[j+1] = add(this.getShoulder(i), scale(Dir, j*L/S));
			}
			Limbs[i].setPoints(P);
			Limbs[i].reset();
		}
	}

	this.getLimb = (i) => Limbs[i];

	this.iterateLimbs = (n) => {
		for (let i = 0; i < N; i++) {
			Limbs[i].iterate(n);
		}
	}


	this.refresh_com = () => {
		com = [0, 0, 0];
		for (let i = 0; i < LPosReal.length; i++) {
			let v = LPosReal[i]; 
			// TODO: Update to make the COM depend mainly on the legs on the ground?
			//scale(LPosReal[i], 1-LimbActivity[i]); // Math.max(1-8*LimbActivity[i], 0));
			com = add(com, v);
		}
		com = add([0,H,0], scale(com, 1/N));
	}

	this.refresh_shoulders = () => {
		shoulders = feet_pattern(rBr-rLr, N, BA);
	}

	// Calculate ideal foot placements given a 
	// centre and angle. Used externally to display
	// the target
	this.calculate_ideal = (p, a) => {
		let feet_pre = feet_pattern(rWr, N, a);
		let R = []
		for (let i = 0; i < N; i++) {
			let x = feet_pre[i][0] + p[0];
			let z = feet_pre[i][2] - p[1];
			R[i] = [x, floor(x,z), z];
		}
		return R;
	}


	this.get_com_Real = () => add(com, [SpX.getPosition(), SpY.getPosition(), SpZ.getPosition()]);
	this.get_com_Ideal = () => com;

	this.getFoot = (i) => LPosReal[i];
	this.getFootIdeal = (i) => LPosIdeal[i];
	this.getFootRealistic = (i) => LPosRealistic[i];
	this.getShoulder = (i) => add(shoulders[i], this.get_com_Real());

	this.setIdeal = (i, v) => { LPosIdeal[i] = v; }
	this.setIdealAngle = (v) => { AngleIdeal = v; }

	this.isActive = (i) => {
		if (LimbActivity[i] > 0)  {
			return 1;
		} 
		return 0;
	}
	this.limbActivity = (i) => LimbActivity[i];

	// Update the target of limb i
	this.updateRealisticTarget = (i)  => {
		// Naive motion: move in +z
		// let p = xz(LPosReal[i]);
		// p[1] -= 0.5;
		// LPosRealistic[i] = [p[0], floor(p[0], p[1]), p[1]];

		// } else {
		// 	LPosRealistic[i] = LPosReal[i];

		// Naive motion: move limbs a fixed distance towards the target
		let D = xz(subtract(LPosIdeal[i], LPosReal[i]));
		let d = norm(D);
		let Stride = sF * H * fL / 2;
		if (d > Stride) {
			// Move 0.5 in the right direction
			let tgt = add([LPosReal[i][0], LPosReal[i][2]], scale(normalize(D), Stride));
			LPosRealistic[i] = [tgt[0], floor(tgt[0], tgt[1]), tgt[1]];
		} else if (d > 0) {
			// Move to target directly
			LPosRealistic[i] = LPosIdeal[i];
		}

		// Motion with planning (Totally broken!)
		// let D = xz(subtract(LPosIdeal[i], LPosReal[i]));
		// let d = norm(D);
		// if (d < 0.5) {
		// 	LPosRealistic[i] = LPosIdeal[i];
		// } else {
		// 	LPosRealistic[i] = this.findStep(i, LPosIdeal[i]);
		// }
	}
	
	// Gets angle from [0, 2pi], where 0 is in the direction of [1,0]
	this.getLimbAngle = (i) => {
		let D = xz(subtract(com, this.getShoulder(i)))
		return atanN(-D[0], D[1]);
	}


	// Get closest feasible position to point p for the joint i
	this.debug_ring_val = (i, p) => {
		let ThetaC = this.getLimbAngle(i);
		let ThetaA = A;
		let X = xz(this.getShoulder(i));
		let ThetaP = atanN(p[0] - X[0], -p[1] + X [1]);
		return (legSeg(ThetaC, ThetaA, ThetaP));
	}

	// Get closest feasible position to point p for the joint i
	this.projectClosest = (i, p) => {
		let ThetaC = this.getLimbAngle(i);
		let ThetaA = A;
		let X = xz(this.getShoulder(i));
		let ThetaP = atanN(p[0] - X[0], -p[1] + X [1]);
		let s = (legSeg(ThetaC, ThetaA, ThetaP));
        if (s == 0) { 
			return p; 
		}
        if (s == 1)  { 
          let AB = [Math.cos(ThetaA - ThetaC), Math.sin(ThetaA - ThetaC)]; 
          let AC = subtract (p, X); 
          let D = add(X, scale(AB, dot(AB, AC)));
		  return D;
        }
        if (s == 2) { 
          let AB = [Math.cos(- ThetaC + Math.PI - ThetaA), Math.sin(- ThetaC + Math.PI - ThetaA)]; 
          let AC = subtract (p, X); 
          let D = add(X, scale(AB, dot(AB, AC)));
		  return D;
        }
        if (s == 3) { 
			return X;
		}
		return [0,0];
	}


	this.findStep = (i, p) => {
		let X = xz(this.getShoulder(i));
		let D = subtract(this.projectClosest(i, p), X);
		if (norm(D) < 0.01) {
			return [X[0], floor(X[0], X[1]), X[1]];
		}
		let DN = normalize(D);

		let SearchLen = 0.5 * L; 
		let SearchMin = 0.1 * L;
		let SearchN = 4;
		for (let i = SearchN; i >= 0; i--) {
			let SL = SearchMin + (i/SearchN) * SearchLen;
			let V = add(X, scale(DN, SL));
			let P = [V[0], floor(V[0], V[1]), V[1]]; 
			if(distance(P, com) < L) {
				return P;
			}
		}

		return [X[0], floor(X[0], X[1]), X[1]];
	};



	this.animateFeet = () => {
		for (let i = 0; i < N; i++) {
			let a = this.limbActivity(i);
			// If it's active: move it
			// If it's not active, do not change it 
			if (this.isActive(i)) {
				let d = Math.min(0.5,distance(LPosLast[i], LPosRealistic[i])); // Move feet higher the further to go
				LPosReal[i] = add(LPosLast[i], scale(subtract(LPosRealistic[i], LPosLast[i]), a));
				LPosReal[i][1] += d * this.foot_height(a);
			}
		}
	}

	this.foot_height = (p) => fL * (Math.sin(Math.PI/4 + p * Math.PI/2) - Math.sin(Math.PI/4));

	this.distance_to_ideal = () => {
		let d = 0;
		for (let i = 0; i < N; i++) {
			d += distance(LPosIdeal[i], LPosReal[i]);
		}
		return d;
	}

	this.angle_to_ideal = () => Math.abs(AngleIdeal - BA);
	this.setsF = (x) => {sF = x};

	this.update = (t) => {
		// Check to see if we should be moving
		if (this.distance_to_ideal() + this.angle_to_ideal() > 0.001) {
			if (isMoving == 0) { motionStarted = t; }
			isMoving = 1;
		} else {
			isMoving = 0;
		}

		if (isMoving) {
			let t_rel = t - motionStarted;

			// Update the activity and target (if appropriate) of each limb
			// HACK: Cascade start offsets for N=4 and this permutation 
			let CST = (tS + tP) / 4.0;
			let CSO = [0,3*CST,CST,2*CST];

			LimbActiveP = (t_rel / (tS + tP)) % 1.0;   // Interpolate [0,1] in (tS + tP) seconds
		    for (let i = 0; i < N; i++) {
		    	let group = (i % (N / 2));
		    	// Not sure how to do this in general, so I'll fix N=8;
		    	// let off = [0,2,3,1]; // Also looks pretty good
		    	let off = [0,1,3,2];
		    	let offset = off[group] / (N / 2);
		    	let val = (tS + tP) * ((LimbActiveP + offset) % 1.0);

		    	if (val < tS && t_rel > CSO[group]) {
					// If the limb wasn't prevoiusly active....
					if (LimbActivity[i] == 0) {
						LPosLast[i] = LPosReal[i];			// Save its past state
						this.updateRealisticTarget(i);		// Update its target
					}
		    		LimbActivity[i] = val / tS;
		    	} else {
		    		LimbActivity[i] = 0;
		    	}
		    }

			// Update the angle of the body
			BA = mix(BA, AngleIdeal, rT);
		}

		this.animateFeet();


		// Refresh the COM, and apply forces to the spring
		let com_old = clone3(com); 
		let SpringSimTime = (t - LastSpringUpdateTime);
		this.refresh_com();
		let com_force = (subtract(com, com_old));
		SpX.setForce(com_force[0]);
		SpY.setForce(com_force[1]);
		SpZ.setForce(com_force[2]);
		SpX.update(SpringSimTime);
		SpY.update(SpringSimTime);
		SpZ.update(SpringSimTime);
		LastSpringUpdateTime = t;


		// Move shoulders include new angle
		this.refresh_shoulders();
		this.resetLimbs();
		this.iterateLimbs(2);
	}


	let N = 0, L = 0, A = 0, S = 0, H = 0, M = 0, BA = 0, rT = 0;
	let rBr = 0, rLr = 0, rWr = 0; // rLr and rWr are derived
	let tS = 0, tP = 0; 		
	let fL = 0; // Foot lift
	let TSpawn = 0;
	let com = [];       // Derived
	let shoulders = []; // Derived
	let LPosReal = [];
	let LPosIdeal = [];
	let LPosRealistic = [];
	let LPosLast = [];
	let LastAngle = 0;
	let AngleIdeal = 0;

	let isMoving = 0;
	let motionStarted = 0;

	let LastSpringUpdateTime = 0;

	let LimbGroups = 2;
	let LimbGroupActive = -1;
	let LimbActivated = 0, LimbFreed = 0;
	let LimbActivity = [];
	let LimbActiveP = 0;

	let Limbs = [];

	let SpX = undefined;
	let SpY = undefined;
	let SpZ = undefined;
	let floor = undefined;
}


