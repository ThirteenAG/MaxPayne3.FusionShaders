sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
float bumpiness : register(c198);
float4 gAmbientOcclusionEffect : register(c63);
float4 gDistFadeParams : register(c97);
float4 gStencil : register(c61);
row_major float4x4 gViewInverse : register(c12);
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
	float3 texcoord6 : TEXCOORD6;
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
	float4 r2;
	r0.x = saturate(-1 + i.color.x);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	o.color.xyz = r0.xxx * globalScalars2.zzz + r1.xyz;
	r0.x = r1.w * i.color.w;
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
	r0.yz = float2(0.5, 0.0051020407);
	r0.z = saturate(r0.z * specularFactor.x);
	r0.z = rsqrt(r0.z);
	r0.z = 1 / r0.z;
	r0.z = rsqrt(r0.z);
	r0.z = 1 / r0.z;
	r1.xw = float2(1, 0);
	r0.w = r1.x + -specularFactor.x;
	o.color2.y = (r0.w >= 0) ? 0.26726124 : r0.z;
	o.color2.z = gAmbientOcclusionEffect.w * i.color.x;
	r0.y = r0.x * globalScalars.x + -r0.y;
	r0.x = r0.x * globalScalars.x;
	r2 = (r0.y >= 0) ? 0 : -1;
	clip(r2);
	r2.xyz = -gViewInverse[3].xyz + i.texcoord6.xyz;
	r0.z = dot(r2.xyz, r2.xyz);
	r0.z = rsqrt(r0.z);
	r0.z = 1 / r0.z;
	r0.zw = r0.zz + float2(-0.65, -0.9);
	r0.z = saturate(r0.z);
	r0.z = r0.z + -1;
	r0.z = (r0.w >= 0) ? r0.z : -0.75;
	r0.z = gDistFadeParams.x * r0.z + r1.x;
	o.color.w = (r0.y >= 0) ? r0.z : 0;
	o.color1.w = r0.x;
	o.color2.w = r0.x;
	o.color2.x = specularColorFactor.x;
	o.color3 = r1.wwwx * gStencil.x;

	return o;
}
