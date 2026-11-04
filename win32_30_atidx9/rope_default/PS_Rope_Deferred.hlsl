sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
float bumpiness : register(c198);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float specularColorFactor : register(c197);
float specularFactor : register(c196);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	r0.x = saturate(-1 + i.color.x);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	o.color.xyz = r0.xxx * globalScalars2.zzz + r1.xyz;
	r0.x = r1.w * i.color.w;
	r0.x = r0.x * globalScalars.x;
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
	r0.z = 0.0051020407;
	r0.y = saturate(r0.z * specularFactor.x);
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	r1.xw = float2(1, 0);
	r0.z = r1.x + -specularFactor.x;
	o.color2.y = (r0.z >= 0) ? 0.071428575 : r0.y;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.w = r0.x;
	o.color2.x = specularColorFactor.x;
	o.color2.z = i.color.x;
	o.color3 = r1.wwwx * gStencil.x;

	return o;
}
