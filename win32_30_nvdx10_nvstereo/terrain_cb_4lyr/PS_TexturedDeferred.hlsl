sampler2D BumpSampler_layer0 : register(s1);
sampler2D BumpSampler_layer1 : register(s3);
sampler2D BumpSampler_layer2 : register(s5);
sampler2D BumpSampler_layer3 : register(s7);
sampler2D TextureSampler_layer0 : register(s0);
sampler2D TextureSampler_layer1 : register(s2);
sampler2D TextureSampler_layer2 : register(s4);
sampler2D TextureSampler_layer3 : register(s6);
float bumpiness : register(c2);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float specularColorFactor : register(c1);
float specularFactor : register(c0);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 color : COLOR;
	float3 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
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
	float4 r2;
	float4 r3;
	r0.xyz = 1 + -i.color.xyz;
	r0.y = r0.y * r0.x;
	r0.w = r0.z * r0.y;
	r0.xy = r0.xy * i.color.yz;
	r1 = i.texcoord.xyxx * float4(1, 1, 0, 0) + float4(0, 0, 0, -1.3);
	r2 = tex2Dbias(TextureSampler_layer1, r1);
	r2.xyz = r0.yyy * r2.xyz;
	r3 = tex2Dbias(TextureSampler_layer0, r1);
	r2.xyz = r3.xyz * r0.www + r2.xyz;
	r0.z = r0.z * r0.x;
	r0.x = r0.x * i.color.z;
	r3 = tex2Dbias(TextureSampler_layer2, r1);
	r1 = tex2Dbias(TextureSampler_layer3, r1);
	r2.xyz = r3.xyz * r0.zzz + r2.xyz;
	r1.xyz = r1.xyz * r0.xxx + r2.xyz;
	r1.w = saturate(-1 + i.texcoord3.w);
	r1.w = r1.w * globalScalars2.z;
	o.color.xyz = r1.xyz * i.texcoord3.xyz + r1.www;
	r1 = tex2D(BumpSampler_layer1, i.texcoord.xy);
	r1.z = -r1.w + 1;
	r1.z = -r1.x + r1.z;
	r1.xy = (r1.zz >= 0) ? r1.wy : r1.xy;
	r1.xy = r0.yy * r1.xy;
	r2 = tex2D(BumpSampler_layer0, i.texcoord.xy);
	r0.y = -r2.w + 1;
	r0.y = -r2.x + r0.y;
	r1.zw = (r0.yy >= 0) ? r2.wy : r2.xy;
	r0.yw = r1.zw * r0.ww + r1.xy;
	r1 = tex2D(BumpSampler_layer2, i.texcoord.xy);
	r1.z = -r1.w + 1;
	r1.z = -r1.x + r1.z;
	r1.xy = (r1.zz >= 0) ? r1.wy : r1.xy;
	r0.yz = r1.xy * r0.zz + r0.yw;
	r1 = tex2D(BumpSampler_layer3, i.texcoord.xy);
	r0.w = -r1.w + 1;
	r0.w = -r1.x + r0.w;
	r1.xy = (r0.ww >= 0) ? r1.wy : r1.xy;
	r0.xy = r1.xy * r0.xx + r0.yz;
	r0.xy = r0.xy + -0.5;
	r0.xy = r0.xy * bumpiness.xx;
	r0.xy = r0.xy + r0.xy;
	r1.xyz = r0.xxx * i.texcoord4.xyz;
	r0.x = dot(r0.xy, -r0.xy) + 1;
	r1.w = max(r0.x, 0);
	r0.x = rsqrt(r1.w);
	r0.x = 1 / r0.x;
	r0.xzw = i.texcoord2.xyz * r0.xxx + r1.xyz;
	r0.xyz = r0.yyy * i.texcoord5.xyz + r0.xzw;
	r0.xyz = r0.xyz + 1E-05;
	r1.xyz = normalize(r0.xyz);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	r0.y = 0.0051020407;
	r0.x = saturate(r0.y * specularFactor.x);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	o.color2.y = 1 / r0.x;
	o.color2.z = gAmbientOcclusionEffect.w * i.texcoord3.w;
	o.color.w = 0;
	o.color1.w = globalScalars.x;
	o.color2.x = specularColorFactor.x;
	o.color2.w = globalScalars.x;
	r0.xy = float2(1, 0);
	o.color3 = r0.yyyx * gStencil.x;

	return o;
}
