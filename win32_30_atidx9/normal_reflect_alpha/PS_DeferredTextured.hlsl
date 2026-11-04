sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
sampler2D EnvironmentSampler : register(s2);
float bumpiness : register(c196);
float fresnelRolloff : register(c198);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float reflectivePower : register(c197);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color3 : COLOR3;
	float4 color2 : COLOR2;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	float3 r3;
	r0.x = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.y = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r2 = lerp(r0.yyy, r1.xyz, gAdrenoFXVars.xxx);
	r3 = lerp(r1.xyz, r2.xyz, r0.xxx);
	r0.x = r1.w * i.color.w;
	r0.y = saturate(-1 + i.color.x);
	o.color.xyz = r0.yyy * globalScalars2.zzz + r3.xyz;
	r1 = tex2D(BumpSampler, i.texcoord.xy);
	r0.y = -r1.w + 1;
	r0.y = -r1.x + r0.y;
	r0.yz = (r0.yy >= 0) ? r1.wy : r1.xy;
	r0.yz = r0.yz * 2 + -1;
	r0.yz = r0.yz * bumpiness.xx;
	r0.w = dot(r0.yz, -r0.yz) + 1;
	r1.x = max(r0.w, 0);
	r0.w = rsqrt(r1.x);
	r0.w = 1 / r0.w;
	r1.xyz = r0.yyy * i.texcoord4.xyz;
	r1.xyz = r0.www * i.texcoord1.xyz + r1.xyz;
	r0.yzw = r0.zzz * i.texcoord5.xyz + r1.xyz;
	r0.yzw = r0.yzw + 1E-05;
	r1.xyz = normalize(r0.yzw);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	r0.yzw = 1E-05 + i.texcoord3.xyz;
	r2 = normalize(r0.yzw);
	r0.y = dot(-r2.xyz, r1.xyz);
	r0.y = r0.y + r0.y;
	r0.yzw = r1.xyz * -r0.yyy + -r2.xyz;
	r1.x = saturate(dot(r2.xyz, r1.xyz));
	r1.x = -r1.x + 1.00001;
	r2.x = pow(r1.x, 5.00001);
	r0.yzw = r0.yzw + 1E-05;
	r0.z = dot(r0.yzw, r0.yzw);
	r0.z = rsqrt(r0.z);
	r0.yz = r0.yw * r0.zz + 1;
	r0.yz = r0.yz * -0.5;
	r1 = tex2D(EnvironmentSampler, r0.yz);
	r3.x = 1;
	r0.y = r3.x + -fresnelRolloff.x;
	r0.y = fresnelRolloff.x * r2.x + r0.y;
	r0.yzw = r0.yyy * r1.xyz;
	r0.yzw = r0.yzw * reflectivePower.xxx;
	r0 = r0 * globalScalars.xwww;
	r0.yzw = saturate(r0.yzw * 0.0625);
	r0.y = rsqrt(r0.y);
	o.color3.x = 1 / r0.y;
	r0.y = rsqrt(r0.z);
	r0.z = rsqrt(r0.w);
	o.color3.z = 1 / r0.z;
	o.color3.y = 1 / r0.y;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.w = r0.x;
	o.color2.xyz = i.color.xxx * float3(0, 0, 1) + float3(0, 0.25, 0);
	o.color3.w = gStencil.x;

	return o;
}
